import 'dart:async';

import 'package:flutter/cupertino.dart';

class DeleteAnuncioProvider with ChangeNotifier{

  bool _deleted = false;

  bool get state => _deleted;

  set state(bool _state){
    _deleted = _state;
    notifyListeners();
  }


  StreamController<bool> _streamController = StreamController<bool>.broadcast();

  Stream<bool> get stream => _streamController.stream;

  set isDeleted(bool _isDeleted){
    _deleted = _isDeleted;
    _streamController.add(_isDeleted);
    notifyListeners();
  }
}