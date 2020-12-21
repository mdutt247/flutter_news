import 'package:flutter/foundation.dart';
import '../../models/UserModel.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = new UserModel();

  UserModel get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}