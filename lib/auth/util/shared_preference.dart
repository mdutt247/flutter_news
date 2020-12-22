import '../../models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("id", user.id);
    prefs.setString("fname", user.fname);
    prefs.setString("lname", user.lname);
    prefs.setString("email", user.email);
    prefs.setString("avatar", user.avatar);
    prefs.setString('token', user.token);

    // TODO
    // ignore: deprecated_member_use
    return prefs.commit();
  }

  Future<UserModel> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id");
    String fname = prefs.getString("fname");
    String lname = prefs.getString("lname");
    String email = prefs.getString("email");
    String avatar = prefs.getString("avatar");
    String token = prefs.getString("token");
    // return new UserModel(id, fname, lname, email, avatar);
    return UserModel(
        id: id,
        fname: fname,
        lname: lname,
        email: email,
        avatar: avatar,
        token: token);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("id");
    prefs.remove("fname");
    prefs.remove("lname");
    prefs.remove("email");
    prefs.remove("avatar");
    prefs.remove("token");
  }

  Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }
}
