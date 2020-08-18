import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/Services/auth.dart';
import 'package:ragapp/models/MinisterioModel.dart';
import 'package:ragapp/models/userModel.dart';
import 'package:ragapp/provider/changeuserDataProvider.dart';
import 'package:ragapp/provider/logOutprovider.dart';
import 'package:ragapp/provider/userImageCropperProvider.dart';
import 'package:ragapp/utils/Widgets/CustomDialog.dart';
import 'package:ragapp/utils/Widgets/BottomSheets/MinisteriobottomSheet.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class userDetailPage extends StatefulWidget {
  final documentId;
  final servidores;
  userDetailPage({@required this.documentId, this.servidores});
  @override
  _userDetailPageState createState() => _userDetailPageState();
}

class _userDetailPageState extends State<userDetailPage> with SingleTickerProviderStateMixin{
  //TODO: global keys
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  //TODO: controllers
  AnimationController _controller;
  PanelController _panelController = PanelController();
  ScrollController _scrollController = ScrollController();
  //TODO: objetos
  FirestoreService _firestoreService = FirestoreService();
  Widgets _widgets = Widgets();
  //TODO: variables
  List<String> _nameDb = [];
  List<String> _iconDb = [];
  List<String> _currentMinisterio =[];
  File croppedFile;
  Size containerSize;
  int userIndex;
  bool _isPanelOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    FirestoreService().closeConnection();
  }
  //TODO: onbackPressed
  Future<bool> response(){
    return _widgets.onBackPressedWithRoute(
        dismissible: true,
        context: context,
        title: 'Cerrar Sesinón',
        fontSize: 13,
        message: 'Esta seguro de cerrar sesión?',
        singOut: true,
        route: null
    );
  }
  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<List<User>>(context);
    final user = Provider.of<User>(context);
    final logOut = Provider.of<LogOutProvider>(context, listen: false);
    final ministerio = Provider.of<List<Ministerio>>(context);
    final updateData = Provider.of<ChangeUserDataProvider>(context, listen: false);
    if(ministerio != null){
      _iconDb.clear();
      _currentMinisterio.clear();
      _nameDb.clear();
      for(int i = 0; i <= ministerio.length-1; i++){
        _currentMinisterio.add(ministerio[i].id);
        _nameDb.add(ministerio[i].name);
        _iconDb.add(ministerio[i].imageUrl);
        _nameDb[i] = ministerio[i].name;
        _iconDb[i] = ministerio[i].imageUrl;
      }
    }
    var _size = MediaQuery.of(context).size;
    return !logOut.state ? user != null
        ? StreamBuilder(
      stream:  _firestoreService.listSingleDocument(documentId: widget.documentId),
      builder: (context, snapshot){
        if(snapshot.data != null){
          return Scaffold(
              resizeToAvoidBottomPadding: false,
              key: scaffoldGlobalKey,
              backgroundColor: Colors.grey[850],
              body: Hero(
                tag: widget.documentId,
                child: Container(
                  color: Colors.grey[850],
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: snapshot.data[0].photoUrl,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            Center(
                              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red),backgroundColor: Colors.grey[850],strokeWidth: 3, value: downloadProgress.progress,),
                            ),
                        filterQuality: FilterQuality.high,
                        imageBuilder: (context, image){
                          return  Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: image,
                                      fit: BoxFit.cover,
                                    )
                                ),
                              ),
                              Container(
                                width: _size.width,
                                height: _size.height,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent,
                                          Colors.transparent,
                                          Colors.transparent,
                                          Colors.transparent,
                                          Colors.black12,
                                          Colors.black38,
                                          Colors.black
                                        ]
                                    )
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Container(
                        width: _size.width,
                        height: _size.height,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.transparent,
                                ]
                            )
                        ),
                      ),
                      //TODO: bottom sheet
                      SlidingUpPanel(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                        color: Colors.black.withOpacity(0.3),
                        minHeight:  (userRole[0].isAdmin) && snapshot.data[0].status != null && snapshot.data[0].status != '' && snapshot.data[0].name.toString().length < 22 ? MediaQuery.of(context).size.height / 3.9
                            : (userRole[0].isAdmin) && snapshot.data[0].status != null && snapshot.data[0].status != '' && snapshot.data[0].name.toString().length >= 22 ? MediaQuery.of(context).size.height / 3.3
                            :(user.uid == snapshot.data[0].uid) && snapshot.data[0].status != null && snapshot.data[0].status != '' && snapshot.data[0].name.toString().length < 22 ? MediaQuery.of(context).size.height / 3.9
                            : (user.uid == snapshot.data[0].uid) && snapshot.data[0].status != null && snapshot.data[0].status != '' && snapshot.data[0].name.toString().length >= 22 ? MediaQuery.of(context).size.height / 3.3
                            : MediaQuery.of(context).size.height / 4.0,

                        maxHeight: 430,
                        isDraggable: true,
                        controller: _panelController,
                        onPanelClosed: (){
                          setState(() {
                            _isPanelOpen = false;
                          });
                        },
                        onPanelOpened: (){
                          setState(() {
                            _isPanelOpen = true;
                          });
                        },
                        panelBuilder: (panelContext){
                          return SingleChildScrollView(
                            controller: _scrollController,
                            physics: NeverScrollableScrollPhysics(),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 6,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[300].withOpacity(0.6)
                                    ),
                                  ),
                                ),
                                _contentState(snapshot: snapshot),
                                Container(
                                  padding: EdgeInsets.only(bottom: 25),
                                  height: 320,
                                  child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: Column(
                                      children: <Widget>[
                                        Visibility(
                                          visible: snapshot.data[0].status == '' && snapshot.data[0].status == null ? false : snapshot.data[0].uid == userRole[0].uid || userRole[0].isAdmin,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                            child: Container(
                                                width: _size.width,
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.white,width: 2),
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                padding: EdgeInsets.symmetric(vertical: 15),
                                                child: RichText(
                                                  maxLines: _isPanelOpen ? 6 : 2,
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: snapshot.data[0].status != '' ? snapshot.data[0].status : userRole[0].isAdmin || snapshot.data[0].uid == user.uid ? 'En este espacio puedes escribir un estado' : '',
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontFamily: 'Glenn Slab'
                                                            )
                                                        ),
                                                        WidgetSpan(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 10),
                                                              child: Visibility(
                                                                visible: userRole[0].isAdmin || user.uid == snapshot.data[0].uid,
                                                                child: InkWell(
                                                                    onTap: (){
                                                                      setState(() {
                                                                        updateData.data = snapshot.data[0].status;
                                                                      });
                                                                      _widgets.changeUserData(
                                                                          size: 270.1,
                                                                          title: 'Actualizar estado',
                                                                          data: snapshot.data[0].status == null ? '' : snapshot.data[0].status,
                                                                          icon: Icon(Icons.textsms),
                                                                          uid: snapshot.data[0].uid,
                                                                          field: 'status',
                                                                          scaffoldGlobalKey: scaffoldGlobalKey,
                                                                          context: context,
                                                                          date: false,
                                                                          keyboardType: TextInputType.text
                                                                      );
                                                                    },
                                                                    child: Icon(Icons.edit, color: Colors.white,)
                                                                ),
                                                              ),
                                                            )
                                                        )
                                                      ]
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: _isPanelOpen?  Icon(Icons.arrow_drop_up, color: Colors.white,) : Icon(Icons.arrow_drop_down, color: Colors.white,),
                                        ),
                                        Visibility(
                                          visible: _isPanelOpen,
                                          child: _contentDetails(snapshot: snapshot, ministerio: ministerio),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 80,
                          width: _size.width,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              )
                          ),
                          child: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            leading: Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async{
                                  Navigator.of(context).pop();
                                },
                                child: Icon(Icons.arrow_back_ios, color: Colors.white,),
                              ),
                            ),
                            actions: <Widget>[
                              Visibility(
                                visible: userRole[0].isAdmin || snapshot.data[0].uid == user.uid ?? false,
                                child: Padding(
                                  padding: snapshot.data[0].uid == user.uid ? EdgeInsets.only(right: 0) : userRole[0].isAdmin ? EdgeInsets.only(right: 20) : EdgeInsets.only(right: 0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async{
                                      await changePhoto(snapshot: snapshot);
                                    },
                                    child: Icon(Icons.camera_alt, color: Colors.white,),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: snapshot.data[0].uid == user.uid ?? false,
                                child: Padding(
                                    padding: EdgeInsets.only(right: 0),
                                    child: PopupMenuButton<String>(
                                      color: Colors.grey[100],
                                      tooltip: 'Configuración',
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),

                                      icon: Icon(Icons.more_vert, color: Colors.white,),
                                      onSelected: choiceAction,
                                      elevation: 10,
                                      itemBuilder: (context){
                                        return [
                                          PopupMenuItem(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text('Cerrar Sesión'),
                                                SizedBox(width: 10,),
                                                Icon(Icons.close, color: Colors.black,),
                                              ],
                                            ),
                                            value: 'salir',
                                          ),
                                        ];
                                      },
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _widgets.statusBar(size: _size)
                    ],
                  ),
                ),
              )
          );
        }else{
          return Container();
        }
      },
    )
        : Container(color: Colors.grey[850],)
        : Container(
      width: _size.width,
      height: _size.height,
      color: Colors.black12.withOpacity(0.1),
      child: Container(
        height: 40,
        width: 40,
        child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red),backgroundColor: Colors.white,strokeWidth: 2,)),
      ),
    );
  }

  Widget _contentState({@required snapshot}){
    final updateData = Provider.of<ChangeUserDataProvider>(context, listen: false);
    final userRole = Provider.of<List<User>>(context);
    final user = Provider.of<User>(context,);
    return Align(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(bottom: 0, left: 20, right: 20, top: 10),
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: snapshot.data[0].name,
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Glenn Slab'
                            )
                        ),
                        WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Visibility(
                                visible: userRole[0].isAdmin || snapshot.data[0].uid == user.uid,
                                child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        updateData.data = snapshot.data[0].name;
                                      });
                                      _widgets.changeUserData(
                                          title: 'Ingrese sú nombre',
                                          data: snapshot.data[0].name,
                                          icon: Icon(Icons.person),
                                          uid: snapshot.data[0].uid,
                                          size: 160.1,
                                          field: 'name',
                                          scaffoldGlobalKey: scaffoldGlobalKey,
                                          context: context,
                                          date: false,
                                          keyboardType: TextInputType.text
                                      );
                                    },
                                    child: Icon(Icons.edit, color: Colors.white)
                                ),
                              ),
                            )
                        )
                      ]
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 8, top: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Visibility(
                    visible: snapshot.data[0].isAdmin,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.star, color: Colors.yellow,),
                        Text('Admin /',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 3,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Material(
                        type: MaterialType.circle,
                        color: snapshot.data[0].isOnline ? Colors.green : Colors.red,
                        child: Container(
                          height: 10,
                          width: 10,
                        ),
                      ),
                      SizedBox(width: 3,),
                      Text(snapshot.data[0].isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget _contentDetails({@required snapshot, @required ministerio}){
    final updateData = Provider.of<ChangeUserDataProvider>(context, listen: false);
    final userRole = Provider.of<List<User>>(context);
    final user = Provider.of<User>(context, listen: false);
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20, top: 10,bottom: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Visibility(
                    visible: userRole[0].isAdmin || snapshot.data[0].ministerios.length  > 0 ? true : false,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Visibility(
                            visible: userRole[0].isAdmin,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                child: InkWell(
                                  child: Icon(Icons.add, color: Colors.white,),
                                  onTap: (){
                                    _bottomSheet(ministerios: ministerio, userMinisterio: snapshot.data[0]);
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8,),
                          //TODO: poner stream builder debajo del otro
                          Container(
                            height: 30,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data[0].ministerios.length,
                              itemBuilder: (context, index){
                                return Row(
                                  children: <Widget>[
                                    Visibility(
                                        visible: snapshot.data[0].ministerios[0] != '' ? true : false,
                                        child: snapshot.data[0].ministerios[0] != '' ? Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                ImageIcon(
                                                  NetworkImage( ministerio[_currentMinisterio.indexOf(snapshot.data[0].ministerios[index])].imageUrl),
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 8,),
                                                Text(
                                                  ministerio[_currentMinisterio.indexOf(snapshot.data[0].ministerios[index])].name,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w300
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ) : Container()
                                    ),
                                    SizedBox(width: 8,),
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: widget.servidores ? 15 : 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.email, color: Colors.white,),
                      SizedBox(width: 8,),
                      Text(
                        snapshot.data[0].email,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: widget.servidores ? 15 : 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.phone, color: Colors.white,),
                          SizedBox(width: 8,),
                          Text(
                            snapshot.data[0].phone != null && snapshot.data[0].phone != '' ? snapshot.data[0].phone : 'No registra.',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w300
                            ),
                          )
                        ],
                      ),
                      Visibility(
                        visible: userRole[0].isAdmin || snapshot.data[0].uid == user.uid,
                        child: InkWell(
                            onTap: (){
                              setState(() {
                                updateData.data = snapshot.data[0].phone;
                              });
                              _widgets.changeUserData(
                                  title: 'Ingrese sú número de telefono',
                                  data: snapshot.data[0].phone == null ? '' : snapshot.data[0].phone,
                                  icon: Icon(Icons.phone),
                                  uid: snapshot.data[0].uid,
                                  field: 'phone',
                                  scaffoldGlobalKey: scaffoldGlobalKey,
                                  context: context,
                                  date: false,
                                  size: 160.1,
                                  keyboardType: TextInputType.numberWithOptions()
                              );
                            },
                            child: Icon(Icons.edit, color: Colors.white,)
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                      visible: userRole[0].isAdmin || snapshot.data[0].uid == user.uid ? true : false,
                      child: SizedBox(height: widget.servidores ? 15 : 10)
                  ),
                  Visibility(
                    visible: userRole[0].isAdmin || snapshot.data[0].uid == user.uid ? true : false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.pin_drop, color: Colors.white,),
                            SizedBox(width: 8,),
                            Text(
                              snapshot.data[0].address != null && snapshot.data[0].address != '' ? snapshot.data[0].address : 'No registra',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300
                              ),
                            )
                          ],
                        ),
                        Visibility(
                          visible: userRole[0].isAdmin || snapshot.data[0].uid == user.uid,
                          child: InkWell(
                              onTap: (){
                                setState(() {
                                  updateData.data = snapshot.data[0].address;
                                });
                                _widgets.changeUserData(
                                    size: 160.1,
                                    title: 'Ingrese sú dirección',
                                    data: snapshot.data[0].address == null ? '' : snapshot.data[0].address,
                                    icon: Icon(Icons.pin_drop),
                                    uid: snapshot.data[0].uid,
                                    field: 'address',
                                    scaffoldGlobalKey: scaffoldGlobalKey,
                                    context: context,
                                    date: false,
                                    keyboardType: TextInputType.text
                                );
                              },
                              child: Icon(Icons.edit, color: Colors.white,)
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*SizedBox(height: widget.servidores ? 15 : 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.date_range, color: Colors.white,),
                          SizedBox(width: 8,),
                          Text(
                            snapshot.data[0].birthDay != null ? formatDate(DateTime.parse(  snapshot.data[0].birthDay.toString()), ['d','/','M','/','yyyy']) : 'No registra',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w300
                            ),
                          )
                        ],
                      ),
                      Visibility(
                        visible: userRole[0].isAdmin || snapshot.data[0].uid == user.uid,
                        child: InkWell(
                            onTap: (){
                              setState(() {
                                updateData.data = snapshot.data[0].birthDay;
                              });
                              _widgets.changeUserData(
                                  size: 160.1,
                                  title: 'Ingrese sú fecha de nacimiento',
                                  data: snapshot.data[0].birthDay == null ? '' : formatDate(DateTime.parse( snapshot.data[0].birthDay.toString()), ['d','/','M','/','yyyy']),
                                  icon: Icon(Icons.date_range),
                                  uid: snapshot.data[0].uid,
                                  field: 'birthDay',
                                  scaffoldGlobalKey: scaffoldGlobalKey,
                                  context: context,
                                  date: true,
                                  keyboardType: TextInputType.text
                              );
                            },
                            child: Icon(Icons.edit, color: Colors.white,)
                        ),
                      ),
                    ],
                  ),*/
                  SizedBox(height: widget.servidores ? 15 : 10),
                  Visibility(
                    visible: userRole[0].isAdmin,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Primer ingreso', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),),
                        SizedBox(width: 8,),
                        Text(
                          formatDate(DateTime.parse( snapshot.data[0].firstJoin.toString()), ['d','/','M','/','yyyy', ' - ','HH',':','nn',':','ss']),
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w300
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Visibility(
                    visible: userRole[0].isAdmin,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Última conexión', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),),
                        SizedBox(width: 8,),
                        Text(
                          formatDate(DateTime.parse(snapshot.data[0].lastJoin.toString()), ['d','/','M','/','yyyy', ' - ','HH',':','nn',':','ss']),
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w300
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }


//TODO cargar ministerios
  void _bottomSheet({@required ministerios, @required userMinisterio}){
    showModalBottomSheet(
        isScrollControlled: false,
        isDismissible: true,
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
            )
        ),
        barrierColor: Colors.black38,
        backgroundColor: Colors.white,
        context: context,
        builder: (context){
          return MinisterioBottomSheet(
            ministerios: ministerios,
            userMinisterio: userMinisterio,
            currentMinisterio: _currentMinisterio,
          );
        }
    );
  }

  //TODO instance
  final picker = ImagePicker();

//TODO: change profile photo
  //TODO: subir foto
  Future changePhoto({@required snapshot,})async{
    final _imageProvider = Provider.of<UserImageProvider>(context, listen: false);
    //TODO variables
    final _image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageProvider.setFile(File(_image.path));
    });
    //TODO: progressbar
    var pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: false
    );
    //TODO: progressbar style
    pr.style(
        backgroundColor: Colors.white,
        borderRadius: 10,
        elevation: 10,
        progressWidget: Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red),backgroundColor: Colors.grey[850],strokeWidth: 3,),
        ),
        message: 'Actualizando informacion',
        messageTextStyle: TextStyle(
        )
    );
    if(_imageProvider.pathImage != null){
      _cropImage();
      Future.delayed(Duration(milliseconds: 2000)).then((value) async{
        if(croppedFile != null){
          //TODO: instance
          StorageReference storageReference = FirebaseStorage().ref().child('perfil');
          //TODO: uploadtask
          await pr.show();
          Future.delayed(Duration(milliseconds: 2000)).then((value) async{
            StorageUploadTask uploadTask = storageReference.child(snapshot.data[0].uid).putFile(croppedFile);
            if(uploadTask != null){
              if(uploadTask.isInProgress){
                //TODO: show progressbar
                await pr.show();
              }else if(uploadTask.isSuccessful){
                Future.delayed(Duration(milliseconds: 100));
                await pr.hide();
              }
            }else{
              _widgets.snackBar(message: 'No se pudo cambiar la foto de perfil', scaffoldGlobalKey: scaffoldGlobalKey, textColor: Colors.black, color: Colors.white.withOpacity(0.92));
            }
            //TODO: on complete task
            await uploadTask.onComplete.then((storageTask) async{
              //TODO: get url image
              String _link = await storageTask.ref.getDownloadURL();
              print(_link);
              //TODO: update user data
              var response = await _firestoreService.updateUserdata(
                  field: 'photoUrl',
                  uid: snapshot.data[0].uid,
                  data: _link
              );
              if(response){
                Future.delayed(Duration(milliseconds: 2000));
                await pr.hide();
                _widgets.snackBar(message: 'Se ha cambiado la foto de perfil correctamente', scaffoldGlobalKey: scaffoldGlobalKey, textColor: Colors.black, color: Colors.white.withOpacity(0.92));
              }else{
                Future.delayed(Duration(milliseconds: 2000));
                await pr.hide();
                _widgets.snackBar(message: 'No se pudo cambiar la foto de perfil', scaffoldGlobalKey: scaffoldGlobalKey, textColor: Colors.black, color: Colors.white.withOpacity(0.92));
              }
            });
          });
        }else{
          Future.delayed(Duration(milliseconds: 2000));
          await pr.hide();
          _widgets.snackBar(message: 'No se pudo cambiar la foto de perfil', scaffoldGlobalKey: scaffoldGlobalKey, textColor: Colors.black, color: Colors.white.withOpacity(0.92));
        }
      });
    }else{
      _widgets.snackBar(message: 'No se pudo cambiar la foto de perfil', scaffoldGlobalKey: scaffoldGlobalKey, textColor: Colors.black, color: Colors.white.withOpacity(0.92));
    }
  }
  //TODO: recortar imagen
  Future<Null> _cropImage() async {
    final _image = Provider.of<UserImageProvider>(context, listen: false);
    croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.pathImage.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.original,
        ]
            : [
          CropAspectRatioPreset.original
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Recortar',
            toolbarWidgetColor: Colors.white,
            toolbarColor: Colors.grey[850],
            cropFrameColor: Colors.grey[850],
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        cropStyle: CropStyle.rectangle,
        iosUiSettings: IOSUiSettings(
          title: 'Recortar',
          aspectRatioLockDimensionSwapEnabled: true,
          aspectRatioLockEnabled: true,
          rotateClockwiseButtonHidden: true,
          showCancelConfirmationDialog: true,
          minimumAspectRatio: MediaQuery.of(context).size.aspectRatio,
          resetAspectRatioEnabled: true,
          doneButtonTitle: 'Guardar',
          cancelButtonTitle: 'Cancelar',
        ),
        compressQuality: 100
    );
    if (croppedFile != null) {
      setState(() {
        _image.setFile(croppedFile);
      });
    }else{
      _image.setFile(File('null'));
    }
  }
  //TODO: pop up menu choice
  void choiceAction(String choice) async{
    final user = Provider.of<User>(context, listen: false);
    final logOut = Provider.of<LogOutProvider>(context, listen: false);
    print('index $choice');
    if(choice == 'salir'){
      setState(() {
        logOut.state = true;
      });
      Navigator.of(context).pop();
      Future.delayed(Duration(milliseconds: 600)).then((value) async{
        await AuthService().signOut(user: user);
        logOut.state = false;
      });
    }
  }
}