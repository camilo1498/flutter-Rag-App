import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/Services/auth.dart';
import 'package:ragapp/provider/changeuserDataProvider.dart';
import 'package:ragapp/provider/deleteAnuncioProvider.dart';

class Widgets{
  var textController = TextEditingController();

  void snackBar({@required scaffoldGlobalKey, message, color, textColor}){
    var _snackbar = SnackBar(
      content: Text(
        '${message.toString()}',
        style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w400
        ),
      ),
      elevation: 5,
      duration: Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,

      backgroundColor: color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),

      action: SnackBarAction(
        onPressed: (){

        },
        label: 'Cerrar',
      ),
    );
    return scaffoldGlobalKey.currentState.showSnackBar(_snackbar);
  }

  Widget userCard({snapshot, index, size, ministerio, currentMinisterio, isService}){
    return Container(
      decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[500],
                blurRadius: 0.5,
                spreadRadius: 0.5,
                offset: Offset(-1, 1.4)
            ),
            BoxShadow(
                color: Colors.grey[500],
                blurRadius: 0.5,
                spreadRadius: 0.5,
                offset: Offset(1, -0.5)
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: snapshot.data[index].photoUrl,
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
            placeholder: (context, url){
              return Center(
                child: Container(
                  width: size.width,
                  height: size.height * 0.2,
                  color: Colors.grey[850],
                  child: Center(
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.transparent,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red),),
                    ),
                  ),
                ),
              );
            },
            imageBuilder: (context, url){
              return Container(
                width: size.width,
                height: size.height * 0.2,
                decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                        image: url,
                        fit: BoxFit.cover
                    )
                ),
              );
            },
          ),
          SizedBox(height: 5,),
          //TODO: name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: snapshot.data[index].name.length >=17 ?'${snapshot.data[index].name.toString().substring(0,17)}...' : snapshot.data[index].name.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Glenn Slab'
                        )
                    ),
                  ]
              ),
            ),
          ),
          //TODO: admin & online mode
          Padding(
            padding: const EdgeInsets.only(right: 10,left: 10, top: 3,bottom: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Visibility(
                  visible: snapshot.data[index].isAdmin,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.star, color: Colors.yellow,size: 12,),
                      Text('Admin /',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontFamily: 'Glenn Slab'
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
                      color: snapshot.data[index].isOnline ? Colors.green : Colors.red,
                      child: Container(
                        height: 7,
                        width: 7,
                      ),
                    ),
                    SizedBox(width: 3,),
                    Text(snapshot.data[index].isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontFamily: 'Glenn Slab'
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          //TODO: ministerio
          Visibility(
            visible: isService,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 20,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data[index].ministerios.length,
                  itemBuilder: (context, indexMinisterio){
                    return Row(
                      children: <Widget>[
                        Visibility(
                            visible:true,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ImageIcon(
                                      NetworkImage(ministerio[currentMinisterio.indexOf(snapshot.data[index].ministerios[indexMinisterio])].imageUrl),
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8,),
                                    Text(
                                      ministerio[currentMinisterio.indexOf(snapshot.data[index].ministerios[indexMinisterio])].name,
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Glenn Slab'
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ),
                        SizedBox(width: 8,),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget userCicularAvatar({user, detailAnuncio, publishedDate}){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            child: CachedNetworkImage(
              imageUrl: user.photoUrl,
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
                  width: 51,
                  height: 51,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      image: DecorationImage(
                          image: url,
                          fit: BoxFit.cover
                      )
                  ),
                );
              },
            )
        ),
        SizedBox(width: 10,),
        Container(
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //TODO: published by user
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  user.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      wordSpacing: 0,
                      letterSpacing: 0,
                      fontFamily: 'Glenn Slab'
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 2,),
              detailAnuncio ? publishedDate : Text(
               '${formatDate(DateTime.parse(DateTime.now().toString()), ['d',' ','M',' ','yyyy'])}',
                style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Glenn Slab'
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void showView({@required context, @required view, @required user, type, userPhoto, userName, userId}){
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              child: Container(
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            type == 'view' ? 'Viewed by (${view.data.length})' : 'Liked by (${view.data.length})',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Nunito',
                              fontSize: 18
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: () async{
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel, color: Colors.red, size: 22,),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 15, left: 15, top: 70,bottom: 15),
                      child: ListView.builder(
                        itemCount: view.data.length,
                        itemBuilder: (context, index){
                          var indexName = userId.indexOf(view.data[index].uid);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                    child: CachedNetworkImage(
                                      imageUrl: userPhoto[indexName],
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
                                          width: 51,
                                          height: 51,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(90),
                                              image: DecorationImage(
                                                  image: url,
                                                  fit: BoxFit.cover
                                              )
                                          ),
                                        );
                                      },
                                    )
                                ),
                                SizedBox(width: 10,),
                                Container(
                                  width: 200,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      //TODO: published by user
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          userName[indexName],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              wordSpacing: 0,
                                              letterSpacing: 0,
                                              fontFamily: 'Nunito'
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Text(
                                        '${formatDate(DateTime.parse(view.data[index].date), ['d',' ','M',' ','yyyy',', ', 'HH',':','nn',':','ss'])}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Nunito'
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              ),
            ),
          ),
        )
    );
  }

  void changeUserData({@required title, icon, data, uid, field, context, scaffoldGlobalKey, keyboardType, date, size}){
    textController.text = data;
    DateTime selectedDate = DateTime.now();
    final updateData = Provider.of<ChangeUserDataProvider>(context, listen: false);
    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1901, 1),
          lastDate: DateTime(2100));
      if (picked != null && picked != selectedDate)
        selectedDate = picked;
      textController.value = TextEditingValue(text: picked.toString());
      updateData.data = textController.text;
    }

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Container(
                height: size,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0, top: 20,left: 20),
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 12
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Container(
                        height: field == 'status' ? 160 : 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(right: 10, left: 10, top: 0),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: date ? GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextField(
                              keyboardType: keyboardType,
                              controller: textController,
                              onChanged: (value){
                                updateData.data = value;
                                print('======== ${textController.text}');
                              },
                              decoration: InputDecoration(
                                  hintText: title,
                                  icon: icon,
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                        ) : TextField(
                          keyboardType: keyboardType,
                          controller: textController,
                          maxLines: field == 'status' ? 5: 1,
                          minLines: 1,
                          maxLengthEnforced: true,
                          buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => field == 'status' ?
                          Text(
                            "${currentLength.toString()}/${maxLength.toString()}",
                            style: TextStyle(
                              color: isFocused ? Colors.red : Colors.grey[850].withOpacity(0.5),
                              fontSize: 10,
                            ),
                          ) : null,
                          maxLength: field == 'status' ? 255 : 30,
                          onChanged: (value){
                            updateData.data = value;
                          },
                          decoration: InputDecoration(
                              hintText: title,
                              icon: icon,
                              border: InputBorder.none
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SheetButton(
                        uid: uid,
                        field: field,
                        data: updateData.data,
                        scaffoldGlobalKey: scaffoldGlobalKey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  showCircularProgressIndicator({@required context, color, text}){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        height: 40,
        width: 40,
        color: color,
        child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red),backgroundColor: Colors.white,strokeWidth: 2,),
                SizedBox(height: 15,),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 12,
                    letterSpacing: 0.7,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            )),
      ),
    );
  }

  Widget statusBar({size}){
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: size.width,
        height: ScreenUtil.statusBarHeight,
        color: Colors.grey[850],
      ),
    );
  }

  void AdminSheet({context, tree}){
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: 400.1,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Administrador',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 22,
                          fontFamily: 'Glenn Slab',
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20,top: 70,left: 10,right: 10),
                    child: tree,
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
  //TODO: backPressed
  Future<bool> onBackPressedWithRoute({@required context,
    @required String title,
    @required double fontSize,
    @required String message,
    @required var route,
    @required var singOut,
    @required var user,
    @required dismissible
  }){
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: dialogContent(
          image: false,
          context: context,
          title: title,
          body: message,
          noButton: new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey[700])
            ),
          ),
          yesButton: new FlatButton(
            onPressed: (){
              if(singOut){
                Navigator.of(context).pop(false);
                AuthService _auth = AuthService();
                _auth.signOut(user: user);
              }
              else{
                print('sin accion');
                Navigator.of(context).pop(true);
              }
            },
            child: Text('Si',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
            color: Colors.grey[700],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
          ),
        ),
      ),
    ) ?? false;
  }


  Future<bool> onDelete({@required context,
    @required String title,
    @required double fontSize,
    @required String message,
    @required var route,
    @required var singOut,
    @required dismissible
  }) async{
    final delete = Provider.of<DeleteAnuncioProvider>(context,listen: false);
    return showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => WillPopScope(
        onWillPop: () async => dismissible,
        child: Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: dialogContent(
            image: true,
            context: context,
            title: title,
            body: message,
            noButton: Container(),
            yesButton: new FlatButton(
              onPressed: (){
                if(singOut){
                }
                else{
                  delete.isDeleted = false;
                  Navigator.of(context).pop(true);
                }
              },
              child: Text('Aceptar',style: TextStyle(color: Colors.white),),
              color: Colors.grey[700],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
        ),
      ),
    ) ?? false;
  }
  dialogContent({BuildContext context, Widget yesButton, Widget noButton, title, body, image}) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 45, bottom: 16, left: 16, right: 16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,

          ),
          child: Container(
            padding: const EdgeInsets.only(top: 15, bottom: 16, left: 16, right: 16),
            margin: EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
                color: Colors.grey[900],//Colors.white
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: Colors.grey[850], width: 1.2),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0.0, 10.0)
                  )
                ]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24,),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w600
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24,),
                Align(
                  child: Row(
                    mainAxisAlignment: image ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Visibility(
                          visible: !image,
                          child: noButton
                      ),
                      yesButton,
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class SheetButton extends StatefulWidget {
  final uid;
  final field;
  final scaffoldGlobalKey;
  var data;
  SheetButton({this.data, this.field, this.uid, this.scaffoldGlobalKey});

  _SheetButtonState createState() => _SheetButtonState();
}

class _SheetButtonState extends State<SheetButton> {
  bool checkingFlight = false;
  bool success = false;
  var response;
  FirestoreService _firestoreService = FirestoreService();
  Widgets _widgets = Widgets();

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ChangeUserDataProvider>(context, listen: false);
    return !checkingFlight
        ? MaterialButton(
      color: Colors.grey[800],
      onPressed: () async {
        setState(() {
          checkingFlight = true;
        });

        await Future.delayed(Duration(seconds:1));
        response = await _firestoreService.updateUserdata(
          field: widget.field,
          uid: widget.uid,
          data: data.data,
        );

        if(response){
          setState(() {
            success = true;
          });
          await Future.delayed(Duration(milliseconds: 1500));

          Navigator.pop(context);
          _widgets.snackBar(
              scaffoldGlobalKey: widget.scaffoldGlobalKey,
              message: 'Datos actualizados correctamente',
            color: Colors.white.withOpacity(0.92),
            textColor: Colors.black
          );
        }else{
          setState(() {
            success = false;
          });
          await Future.delayed(Duration(milliseconds: 1500));

          Navigator.pop(context);
          _widgets.snackBar(
              scaffoldGlobalKey: widget.scaffoldGlobalKey,
              message: 'Error al actualizar los datos',
            color: Colors.white.withOpacity(0.92),
            textColor: Colors.black
          );
        }

      },
      child: Text(
        'Guardar',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    )
        : !success
        ? CircularProgressIndicator()
        : Icon(
      Icons.check,
      color: Colors.green,
    );
  }

}