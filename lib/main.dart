import 'auth/forgot.dart';
import 'auth/logout.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';

import 'auth/dashboard.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import 'auth/welcome.dart';
import 'auth/logout.dart';
import 'auth/providers/auth.dart';
import 'auth/providers/user_provider.dart';
import 'auth/util/shared_preference.dart';
import 'package:provider/provider.dart';
import 'models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  print("In main");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token");
  if(token != null) {
    print("token:" + token);
  }
  else{
    print('token is null');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<UserModel> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                print('home in main' + snapshot.data.toString());
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else if (snapshot.data.token == null)
                      return Login();
                    else
                      UserPreferences().removeUser();
                    return Welcome(user: snapshot.data);
                }
              }),
          routes: {
            '/register': (context) => Register(),
            '/login': (context) => Login(),
            '/dashboard': (context) => DashBoard(),
            '/logout': (context) => Logout(),
            '/reset-password':(context) => Forgot()
          }),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(initialRoute: '/home', routes: {
//       '/': (context) => HomeList(),
//       '/home': (context) => HomeList(),
//       '/dashboard': (context) => DashBoard(),
//       '/login': (context) => Login(),
//       '/register': (context) => Register(),
//       // '/about': (context) => About(),
//       // '/contact': (context) => Contact(),
//       // '/sop': (context) => Sop(),
//     });
//
//     // return MaterialApp(
//     //   title: 'Flutter Demo',
//     //   theme: ThemeData(
//     //     primarySwatch: Colors.red,
//     //     visualDensity: VisualDensity.adaptivePlatformDensity,
//     //   ),
//     //   home: HomeList(),
//     // );
//   }
// }