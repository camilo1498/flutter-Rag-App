import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/models/userModel.dart';
import 'package:ragapp/pages/authenticate/sign_in.dart';
import 'package:ragapp/pages/home/home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  //TODO: object
  FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    if(user != null){
      _firestoreService.updateUserStatus(user: user, isOnline: true, lastJoin: DateTime.now().toString());
      return Home();
    }else{

      return SignIn();
    }

  }
}
