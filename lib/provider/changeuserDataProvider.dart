import 'package:flutter/cupertino.dart';

class ChangeUserDataProvider with ChangeNotifier{

  String _data = '';

  String get data => _data;

  set data(String _d){
    _data = _d;
    notifyListeners();
  }

}