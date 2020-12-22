import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../models/UserModel.dart';
import 'providers/auth.dart';
import 'providers/user_provider.dart';
import 'util/validators.dart';
import 'util/widgets.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // String selectedDept;
  // List data = List();
  //
  // Future getAllDept() async {
  //   var response =
  //       await http.get(AppUrl.getDept, headers: {'Accept': 'application/json'});
  //
  //   var responseData = json.decode(response.body);
  //
  //   setState(() {
  //     data = responseData;
  //   });
  //   print(responseData);
  //   print(data);
  //
  //   return "";
  // }

  @override
  void initState() {
    super.initState();
    // getAllDept();
  }

  final formKey = new GlobalKey<FormState>();

  String first_name, last_name, email, password, password_confirmation;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    // final departmentField = DropdownButton(
    //
    //   autofocus: false,
    //   value: selectedDept,
    //   hint: Text('Select Department'),
    //   items: data.map((list){
    //     return DropdownMenuItem(
    //         child: Text(list['title']),
    //       value: list['id'].toString(),
    //     );
    //   },).toList(),
    //   onChanged: (value) {
    //     setState(() {
    //       selectedDept = value;
    //     });
    //   },
    // );

    final firstnameField = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? "Please enter first name" : null,
      onSaved: (value) => first_name = value,
      decoration: buildInputDecoration("First name", Icons.person),
    );

    final lastnameField = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? "Please enter last name" : null,
      onSaved: (value) => last_name = value,
      decoration: buildInputDecoration("Last name", Icons.person),
    );

    final emailField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      onSaved: (value) => email = value,
      decoration: buildInputDecoration("Email", Icons.email),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Please enter password" : null,
      onSaved: (value) => password = value,
      decoration: buildInputDecoration("Password", Icons.lock),
    );

    final confirmPassword = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? "Your password is required" : null,
      onSaved: (value) => password_confirmation = value,
      obscureText: true,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text("Registering ... Please wait")
      ],
    );

    var doRegister = () {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        auth
            .register(first_name, last_name, email, password,
                password_confirmation) //, selectedDept)
            .then((response) {
          if (response['status']) {
            UserModel user = response['data'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            String combinedMessage = "";
            response["data"]["errors"].forEach((key, messages) {
              for (var message in messages) {
                combinedMessage = combinedMessage + "- $message\n";
              }
              Flushbar(
                title: "Registration failed",
                message: combinedMessage,
                duration: Duration(seconds: 10),
              ).show(context);
            });
          }
        });
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please complete the form properly",
          duration: Duration(seconds: 10),
        ).show(context);
      }
    };

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label("First Name"),
                  firstnameField,
                  SizedBox(height: 1.0),
                  label("Last Name"),
                  lastnameField,
                  // SizedBox(height: 1.0),
                  // label("Department"),
                  // departmentField,
                  SizedBox(height: 1.0),
                  label("Email"),
                  emailField,
                  SizedBox(height: 1.0),
                  label("Password"),
                  passwordField,
                  SizedBox(height: 1.0),
                  label("Confirm Password"),
                  confirmPassword,
                  SizedBox(height: 12.0),
                  auth.registeredInStatus == Status.Registering
                      ? loading
                      : longButtons("Register", doRegister),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
