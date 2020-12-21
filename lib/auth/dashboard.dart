import 'package:flutter/material.dart';
import '../models/UserModel.dart';
import 'providers/auth.dart';
import 'providers/user_provider.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {

    UserModel user = Provider.of<UserProvider>(context).user;
    AuthProvider auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("DASHBOARD PAGE"),
        elevation: 0.1,
      ),
      body: Column(
        children: [
          SizedBox(height: 100,),
          Center(child: Text(user.email)),
          SizedBox(height: 100),
          RaisedButton(
            onPressed:  () async{
              if(await auth.logout()){
                Navigator.pushReplacementNamed(context, '/logout');
              }
              else{
                Text("Error");
              }
              },
            child: Text("Logout"), color: Colors.lightBlueAccent,)

        ],
      ),
    );
  }
}