import 'package:flutter/material.dart';
import 'package:module/model/input.dart';
class UserChangeNotifier with ChangeNotifier {
  Input? _input;

  Input? get input => _input;

  set input(Input? input) {
    _input = input;
    notifyListeners();
  }
}

class InputNotifier with ChangeNotifier {
  Input? _input;

  Input? get input => _input;

  set input(Input? input) {
    _input = input;
    notifyListeners();
  }
}
