import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../models/UserModel.dart';
import 'providers/auth.dart';
import 'providers/user_provider.dart';
import 'util/validators.dart';
import 'util/widgets.dart';
import 'package:provider/provider.dart';

class Forgot extends StatefulWidget {
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final formKey = new GlobalKey<FormState>();

  String _email;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final emailField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      onSaved: (value) => _email = value,
      decoration: buildInputDecoration("Email", Icons.email),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Sending email ... Please wait")
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(0.0),
          child: Text("Sign up",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
           Navigator.pushReplacementNamed(context, '/register');
          },
        ),
        FlatButton(
          padding: EdgeInsets.only(left: 0.0),
          child: Text("Sign in", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );

    var doForgot = () {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();
        final Future<Map<String, dynamic>> successfulMessage =
        auth.forgot(_email);
        successfulMessage.then((response) {
          print('response');
          print(response);
          if (response['status']) {
            // print('mail sent');
            Navigator.pushReplacementNamed(context, '/login');
          } else {
            Flushbar(
              title: "Failed Forgot",
              message: response['message']['data'].toString(),
              // message: response['message']['message'].toString(),
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        print("form is invalid");
      }
    };

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.0),
                label("Email"),
                SizedBox(height: 5.0),
                emailField,
                SizedBox(height: 20.0),
                auth.loggedInStatus == Status.SendingForgotMail
                    ? loading
                    : longButtons("Email password reset link", doForgot),
                SizedBox(height: 5.0),
                forgotLabel
              ],
            ),
          ),
        ),
      ),
    );
  }
}