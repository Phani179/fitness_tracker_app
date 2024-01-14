
import 'package:flutter/material.dart';

class AuthStateProvider extends ChangeNotifier
{
  bool isLogin = true;

  void changeIsLoginState(bool state)
  {
    isLogin = state;
    notifyListeners();
  }
}