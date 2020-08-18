import 'package:flutter/material.dart';

class rightMenuProvider with ChangeNotifier{
  bool _isOpen = false;

  bool get state => _isOpen;

  set state(bool _state){
    _isOpen = _state;
    notifyListeners();
  }

}