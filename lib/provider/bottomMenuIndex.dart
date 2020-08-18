import 'package:flutter/material.dart';

class BottomMenuIndex with ChangeNotifier{
  int _index = 2;

  int get index => _index;

  set index(int _state){
    _index = _state;
    notifyListeners();
  }

}