import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../models/UserModel.dart';
import '../util/app_url.dart';
import '../util/shared_preference.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggingOut,
  LoggedOut,
  SendingForgotMail,
  SendingForgotMailSuccess,
  SendingForgotMailFail,
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();
    print("sending login data...");
    print(loginData);
    Response response = await post(
      AppUrl.login,
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      var userData = responseData['data'];

      UserModel authUser = UserModel.fromJson(userData);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> register(String first_name, String last_name,
      String email, String password, String password_confirmation)async { //, String selectedDept) async {
    final Map<String, dynamic> registrationData = {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'password': password,
      'password_confirmation': password_confirmation,
      //'selectedDept': selectedDept,
    };
    print('sending registration data====');
    print(registrationData);
    print('done sending registration data====');
    return await post(AppUrl.register,
            body: json.encode(registrationData),
            headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 201) {
      var userData = responseData['data'];

      UserModel authUser = UserModel.fromJson(userData);

      UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

  Future<bool> logout() async {
    _loggedInStatus = Status.LoggingOut;
    notifyListeners();

    String token = await UserPreferences().getToken(null);

    Response response = await post(AppUrl.logout, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 201) {
      UserPreferences().removeUser();
      _loggedInStatus = Status.LoggedOut;
      notifyListeners();
      return true;
    } else {
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> forgot(email) async {
    var result;
    final Map<String, dynamic> forgotData = {
      'email': email,
    };

    _loggedInStatus = Status.SendingForgotMail;
    notifyListeners();
    print("sending forgot data...");
    print(forgotData);

    Response response = await post(AppUrl.forgotPassword,
        body: json.encode(forgotData),
        headers: {
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 201) {
      UserPreferences().removeUser();
      _loggedInStatus = Status.SendingForgotMailSuccess;
      notifyListeners();
      result = {
        'status': true,
        'message': 'Successful'
      };
      return result;
    } else {
      _loggedInStatus = Status.SendingForgotMailFail;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
      return result;
    }
  }
}
