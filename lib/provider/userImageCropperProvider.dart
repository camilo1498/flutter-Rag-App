import 'dart:io';

import 'package:flutter/cupertino.dart';

class UserImageProvider with ChangeNotifier{

  static File image;

  File get pathImage => image;

  void setFile(File imageFile){
    image = imageFile;
    notifyListeners();
    print(('listen image ==> ${image.path}'));
  }

}