import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/models/notificationModel.dart';
import 'package:ragapp/models/userModel.dart';
import 'package:ragapp/pages/Anuncios/AnuncioNotification.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  //TODO: global keys
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  //TODO: variables
  List<String> _usersID = [];
  List<String> _likeUsers = [];
  List<String> _likeID = [];
  List<String> _usersName = [];
  List<String> _usersPhoto = [];
  bool longPress = false;
  bool isSelected = false;
  var mycolor;
  @override
  Widget build(BuildContext context) {
    final _notifications = Provider.of<List<NotificationModel>>(context);
    final users = Provider.of<List>(context);
    final userRole = Provider.of<List<User>>(context);
    if(users !=null){
      _usersID.clear();
      _usersName.clear();
      _usersPhoto.clear();
      for(int i = 0; i <= users.length -1; i++){
        _usersID.add(users[i].uid);
        _usersName.add(users[i].name);
        _usersPhoto.add(users[i].photoUrl);
      }
    }
    return Scaffold(
      key: scaffoldGlobalKey,
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        backgroundColor: //Colors.white,
        Colors.grey[900],
        centerTitle: false,
        title: Text(
          'Notificaciones',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: //Colors.black
              Colors.white
          ),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: ImageIcon(
              AssetImage(
                'images/logonotificacion.png',
              ),
              color: //Colors.black,
              Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: _notifications != null ? _notifications.length != 0 ? Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 8,right: 8,left: 0, bottom: 55),
          child: ListView.builder(
            itemCount: _notifications.length,
            itemBuilder: (context, index){
              var indexName = _usersID.indexOf(_notifications[index].uid);
              return Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Card(
                  color: mycolor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ListTile(
                    onTap: () async{
                      if(_notifications[index].isPost){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPageView(message: _notifications[index].docId,onTap: true,)));
                        var _res = await FirestoreService().updateNotificationState(uid: userRole[0].uid, docId: _notifications[index].id);
                        print(userRole[0].uid);
                        print(_notifications[index].id);
                      }
                    },
                    leading: _userAvatar(users: users, indexName: indexName),
                    title: Container(
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 290,
                                    child: RichText(
                                      text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:  '${users[indexName].name}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: //Colors.black
                                                Colors.red,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' te ha enviado una notificación.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: //Colors.black
                                                  Colors.grey[900]
                                              ),
                                            ),
                                          ]
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _notifications[index].title != null &&  _notifications[index].title != '' ? _notifications[index].title.toString() : '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: //Colors.black
                                        Colors.grey[900]
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      timeago.format(DateTime.parse(_notifications[index].date,),locale: 'en_short'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.3,
                                          wordSpacing: -0.3,
                                          fontSize: 10.5,
                                          color: //Colors.grey[500],
                                          Colors.grey[500]
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Visibility(
                          visible: !_notifications[index].view,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                '1',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: //Colors.black
                                    Colors.white,
                                    fontSize: 10
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 42,
                          width: 30,
                          child: PopupMenuButton<String>(
                            color: Colors.grey[100],
                            tooltip: 'Opciones',
                            icon: Icon(Icons.more_vert, color: Colors.grey[900],),
                            elevation: 10,
                            itemBuilder: (context){
                              return [
                                PopupMenuItem(
                                  child: InkWell(
                                    onTap: () async{
                                      Navigator.pop(context);
                                      await FirestoreService().deleteNotification(docId: _notifications[index].id, uid: userRole[0].uid);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Eliminar'),
                                        SizedBox(width: 10,),
                                        Icon(Icons.close, color: Colors.black,),
                                      ],
                                    ),
                                  ),
                                  value: 'salir',
                                ),
                              ];
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              );
            },
          ),
        ),
      ) : message(): message(),
    );
  }
}

//TODO: sin contenido
Widget message(){
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.error_outline,
          color: //Colors.black38.withOpacity(0.2),
          Colors.grey[400],
          size: 100,),
        SizedBox(height: 5,),
        Text(
          'No Tienes notificaciones.',
          style: TextStyle(
              color://Colors.black38.withOpacity(0.2),
              Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w600
          ),
        )
      ],
    ),
  );
}
//TODO: userAvatar
Widget _userAvatar({users, indexName}){
  return Container(
      child: CachedNetworkImage(
        imageUrl: users[indexName].photoUrl,
        filterQuality: FilterQuality.high,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red),backgroundColor: Colors.grey[850],strokeWidth: 3, value: downloadProgress.progress,),
            ),
        placeholder: (context, url){
          return Container(
            child: CircularProgressIndicator(),
          );
        },
        imageBuilder: (context, url){
          return Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                image: DecorationImage(
                    image: url,
                    fit: BoxFit.cover
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[500],
                      blurRadius: 0.5,
                      spreadRadius: 0.5,
                      offset: Offset(0, 1.5)
                  )
                ]
            ),
          );
        },
      )
  );
}
