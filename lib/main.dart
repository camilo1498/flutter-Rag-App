import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/LifeCicle/LifeCicle.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/Services/auth.dart';
import 'package:ragapp/models/AnuncioModel.dart';
import 'package:ragapp/models/MinisterioModel.dart';
import 'package:ragapp/models/notificationModel.dart';
import 'package:ragapp/models/userModel.dart';
import 'package:ragapp/models/videoModel.dart';
import 'package:ragapp/pages/Anuncios/AnuncioNotification.dart';
import 'package:ragapp/provider/bottomMenuIndex.dart';
import 'package:ragapp/provider/changeuserDataProvider.dart';
import 'package:ragapp/provider/deleteAnuncioProvider.dart';
import 'package:ragapp/provider/logOutprovider.dart';
import 'package:ragapp/provider/pushNotificationProvider.dart';
import 'package:ragapp/provider/rigthMenuProvider.dart';
import 'package:ragapp/pages/Wrapper.dart';
import 'package:ragapp/provider/userImageCropperProvider.dart';

void main() async{

  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey[900]
  ));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //TODO: menu state
  rightMenuProvider _menuProvider = rightMenuProvider();
  ChangeUserDataProvider _userDataProvider = ChangeUserDataProvider();
  UserImageProvider _userImageProvider = UserImageProvider();
  LogOutProvider _logOutProvider = LogOutProvider();
  BottomMenuIndex _menuIndex = BottomMenuIndex();
  DeleteAnuncioProvider _deleteAnuncioProvider = DeleteAnuncioProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider.value(value: AuthService().user),
          ChangeNotifierProvider.value(value: _menuProvider,),
          ChangeNotifierProvider.value(value: _userDataProvider),
          ChangeNotifierProvider.value(value: _userImageProvider),
          ChangeNotifierProvider.value(value: _logOutProvider),
          ChangeNotifierProvider.value(value: _menuIndex),
          ChangeNotifierProvider.value(value: _deleteAnuncioProvider),
          StreamProvider<List<Publicaciones>>.value(value: FirestoreService().listAllPublicaciones()),
          StreamProvider<List>.value(value: FirestoreService().listAllUsers(),),
          StreamProvider<List<Video>>.value(value:  FirestoreService().videoRealTimeData()),
          StreamProvider<List<Ministerio>>.value(value: FirestoreService().ministerioRealTimerData(),initialData: null,)
        ],
        child: BuildUser()
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
class BuildUser extends StatefulWidget {
  @override
  _BuildUserState createState() => _BuildUserState();
}

class _BuildUserState extends State<BuildUser> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return  StreamProvider<List<User>>.value(
      value: FirestoreService().listSingleDocument(documentId: user != null ? user.uid : null),
      child: AuthService().user != null ? LifeCycleManager(
          child: StreamProvider<List<NotificationModel>>.value(
            value: FirestoreService().notificationListener(uid:user != null ? user.uid : null),initialData: null,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Rag App',
              theme: ThemeData(
                primaryColor: Colors.red,
                accentColor: Colors.red,
                fontFamily: 'Glenn Slab',
              ),
              home: MyHomePage()
            ),
          )
      ) : Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ) ;
  }
}
////////////////////////////////////////////////////////////////////////////////

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
final PushNotificationProvider _notificationProvider = PushNotificationProvider();
class _MyHomePageState extends State<MyHomePage> {
  showAlertDialog(BuildContext context, message) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("on Message Notification"),
      content: Text(
           message.toString()),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    _notificationProvider.initNotifications();

    _notificationProvider.messages.listen((message) async{

      print('data onMessage => ${message.toString()}');
      if(message['type'] == 'onMessage'){
        print('if data => ${message.toString()}');
        await FirestoreService().createNotification(message: message, context: context);

        //showAlertDialog(context, message);
      }else if(message['type'] == 'onLaunch'){
        print('else data onLaunch=> ${message.toString()}');
        Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPageView(message: message,onTap: false,)));
        await FirestoreService().createNotification(message: message, context: context);

      }else if(message['type'] == 'onResume'){
        print('else data onResume => ${message.toString()}');
        Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPageView(message: message,onTap: false,)));
        await FirestoreService().createNotification(message: message, context: context);

      }else{
        print(message);
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Wrapper();
  }
}
