import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/models/AnuncioModel.dart';
import 'package:ragapp/models/userModel.dart';
import 'package:ragapp/utils/Widgets/AnimatedPageRoute/MaterialFadeTransition.dart';
import 'package:ragapp/utils/Widgets/Gallery/gallery.dart';
import 'package:ragapp/utils/Widgets/publicacionesWidgets/publicacionesBuilders.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class NotificationPageView extends StatefulWidget {
  final message;
  final onTap;
  NotificationPageView({this.message,this.onTap});
  @override
  _NotificationPageViewState createState() => _NotificationPageViewState();
}

class _NotificationPageViewState extends State<NotificationPageView> {
  //TODO: global keys
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  //TODO: objetos
  FirestoreService _firestoreService = FirestoreService();
  CustomBuilders _customBuilders = CustomBuilders();

  //TODO: controllers
  FocusNode _textNode = FocusNode();
  TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  //TODO: variables
  List<String> _usersID = [];
  List<String> _likeUsers = [];
  List<String> _likeID = [];
  List<String> _usersName = [];
  List<String> _usersPhoto = [];
  bool _isEditingContent = false;
  var _editingIndex;
  int snapshotIndex;
  int indexName;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  _launchURL(url) async {
    print('launch url!');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    //TODO call provider
    final snapshot = Provider.of<List<Publicaciones>>(context);
    final users = Provider.of<List>(context);
    final userRole = Provider.of<List<User>>(context);
    setState(() {
      if(widget.onTap){
        snapshotIndex = snapshot.indexWhere((element) => element.id ==widget.message.toString());
      }else{
        snapshotIndex = snapshot.indexWhere((element) => element.id ==widget.message['content']['data']['docId'].toString());
      }
    });
    //TODO: screen size
    var _size = MediaQuery.of(context).size;
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
    if(snapshotIndex != -1){
      setState(() {
        indexName = _usersID.indexOf(snapshot[snapshotIndex].publishedBy) ?? null;
      });
    }
    return Scaffold(
        key: scaffoldGlobalKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: //Colors.white,
          Colors.grey[900],
          centerTitle: false,
          leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white,),
          ),
          titleSpacing: 0,
          title: Text(
            'Rag App',
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
        body: //Center(child: Text(widget.message['content']['data']['docId'])),
        snapshotIndex != -1 ? Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  StreamProvider<List<Comments>>.value(
                    value: _firestoreService.viewComment(id: snapshot[snapshotIndex].id),
                    child: Builder(
                      builder: (context){
                        var comments = Provider.of<List<Comments>>(context);
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0.1, -0.1),
                                        color: Colors.grey[400],
                                        spreadRadius: 0.8,
                                        blurRadius: 1
                                    )
                                  ]
                              ),
                              child: Column(
                                children: <Widget>[
                                  //TODO: user Info
                                  Container(
                                    padding: EdgeInsets.only(right: 15, left: 15, top: 15,),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            _userAvatar(users: users,indexName: indexName),
                                            SizedBox(width: 10,),
                                            Container(
                                              height: 45,
                                              child:  Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    users[indexName].name,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w800,
                                                        letterSpacing: -0.3,
                                                        wordSpacing: -0.3,
                                                        fontSize: 13.5,
                                                        color: Colors.black
                                                      //Colors.white
                                                    ),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: <Widget>[
                                                      Visibility(
                                                        visible: users[indexName].isAdmin,
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(vertical: 1,horizontal: 1),
                                                          decoration: BoxDecoration(
                                                              color: Colors.black,
                                                              borderRadius: BorderRadius.circular(20)
                                                          ),
                                                          child: Center(
                                                            child: Icon(Icons.star, color: Colors.yellow, size: 12,),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Text(
                                                        timeago.format(DateTime.parse(snapshot[snapshotIndex].publishedDate,),locale: 'en_short'),
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: -0.3,
                                                            wordSpacing: -0.3,
                                                            fontSize: 10.5,
                                                            color: //Colors.grey[500],
                                                            Colors.grey[500]
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  //TODO: content
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: snapshot[snapshotIndex].content != null && snapshot[snapshotIndex].content != '' ? EdgeInsets.only(right: 15, left: 15, top: 0, bottom: 15) : EdgeInsets.all(0),
                                    child: MarkdownBody(
                                      onTapLink: (link){
                                        _launchURL(link);
                                      },
                                      data: snapshot[snapshotIndex].content,
                                      styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
                                      styleSheet: MarkdownStyleSheet(
                                        p: _textStyle(size: 15.1),
                                        h1: _textStyle(size: 25.1),
                                        h2: _textStyle(size: 21.1),
                                        h3: _textStyle(size: 17.1),
                                        h4: _textStyle(size: 16.1),
                                        h5: _textStyle(size: 15.1),
                                        h6: _textStyle(size: 14.1),
                                        listBullet: TextStyle(
                                          color: //Colors.white,
                                          Colors.grey[900],
                                        ),
                                        //TODO:list color
                                        a: TextStyle(
                                            color: Colors.blue,
                                            //Colors.grey[900],
                                            fontSize: 14,
                                            fontFamily: 'Glenn Slab'
                                        ),
                                        strong: TextStyle(
                                            color: Colors.grey[900],//Colors.white,
                                            fontWeight: FontWeight.w800
                                        ),
                                      ),
                                      selectable: false,
                                    ),
                                  ),
                                  //TODO: image builder
                                  Column(
                                    // key: _containerKey,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      snapshot[snapshotIndex].gallery == null ? Container()
                                          :  snapshot[snapshotIndex].gallery.length == 0 ? Container():
                                      setImage(path: snapshot[snapshotIndex].gallery, height: snapshot[snapshotIndex].heightSize)
                                    ],
                                  ),
                                  //TODO option bar
                                  Container(
                                      width: _size.width,
                                      height: 50,
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Container(
                                              width: _size.width/3,
                                              child: Center(
                                                child:   StreamBuilder<List<LikeByUser>>(
                                                  stream: _firestoreService.likeCount(id: snapshot[snapshotIndex].id),
                                                  builder: (context, like){
                                                    _likeUsers.clear();
                                                    _likeID.clear();
                                                    if(like.data != null){
                                                      for(int i = 0; i<= like.data.length -1 ; i++){
                                                        _likeUsers.add(like.data[i].uid);
                                                        _likeID.add(like.data[i].id);
                                                      }
                                                    }
                                                    return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        _customBuilders.likeBuilder(
                                                            userRole: userRole,
                                                            snapshot: snapshot,
                                                            context: context,
                                                            index: snapshotIndex,
                                                            likeUsers: _likeUsers,
                                                            likeID: _likeID,
                                                            like: like
                                                        ),
                                                        SizedBox(height: 3.5,),
                                                        Text(
                                                          'me gusta',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors.grey[700]
                                                            //Colors.grey[400]
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: _size.width/3,
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        ImageIcon(
                                                            AssetImage('icons/comentario.png'),
                                                            color: Colors.grey[900]
                                                          //Colors.white
                                                        ),
                                                        SizedBox(width: 12,),
                                                        Text(
                                                          comments != null ? (comments.length-1).toString() : '0',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.grey[700]
                                                            //Colors.grey[400]
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Text(
                                                      'comentarios',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey[700]
                                                        //Colors.grey[400]
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: _size.width/3,
                                              child: Center(
                                                child:   Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    ImageIcon(
                                                        AssetImage('icons/compartir.png'),
                                                        color: Colors.grey[900]
                                                      //Colors.white
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Text(
                                                      'compartir',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey[700]
                                                        //Colors.grey[400]
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]
                                      )
                                  ),
                                  SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 35),
                                    child: Container(
                                      height: 1,
                                      width: _size.width,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[400]
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Container(
                                    height: 500.1,
                                    padding: EdgeInsets.only(left: 10, bottom: 50),
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: comments!= null ? comments.length : 0,
                                      itemBuilder: (context, index){
                                        if(comments != null && comments.length != 0){
                                          Future.delayed(Duration(milliseconds: 500)).then((value){
                                            if(_scrollController.positions.isNotEmpty && !_isEditingContent){
                                              _scrollController.animateTo(_scrollController.position.maxScrollExtent,duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                                            }
                                          });
                                        }
                                        return Visibility(
                                          visible: comments[index].visible,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                _userAvatar(indexName: indexName, users: users),
                                                SizedBox(width: 10,),
                                                Container(
                                                  padding: EdgeInsets.only(top: 10,bottom: 10,left: 10, right: 1),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.only(
                                                          topRight: Radius.circular(15),
                                                          bottomLeft: Radius.circular(15),
                                                          bottomRight: Radius.circular(15)
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset: Offset(0.1, 0.1),
                                                            color: Colors.grey[400],
                                                            spreadRadius: 0.5,
                                                            blurRadius: 3
                                                        )
                                                      ]
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                            '${users[indexName].name}',
                                                            style: TextStyle(
                                                                color: Colors.grey[900],
                                                                fontWeight: FontWeight.w800,
                                                                fontSize: 14
                                                            ),
                                                          ),
                                                          SizedBox(height: 3,),
                                                          Container(
                                                            constraints: BoxConstraints(
                                                              maxWidth: MediaQuery.of(context).size.width/1.6,
                                                            ),
                                                            child: Text(
                                                              '${comments[index].message}',

                                                              textAlign: TextAlign.left,
                                                              style: TextStyle(
                                                                  color: Colors.grey[900],
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 14
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 1,),
                                                          Text(
                                                            '${timeago.format(DateTime.parse(comments[index].date,),locale: 'en_short')}',
                                                            style: TextStyle(
                                                                color: Colors.grey[500],
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 10
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Visibility(
                                                        visible: userRole[0].uid == comments[index].uid || userRole[0].isAdmin,
                                                        child: InkWell(
                                                            onTap: (){
                                                              adminSheet(
                                                                uid: comments[index].uid,
                                                                context: context,
                                                                content: comments[index].message,
                                                                docId: comments[index].id,
                                                              );
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.only(left: 2,right: 2),
                                                              child: Icon(Icons.more_vert, color: Colors.grey[900],size: 20,),
                                                            )
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              )
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0.1, -0.1),
                          color: Colors.grey[400],
                          spreadRadius: 0.5,
                          blurRadius: 3
                      ),
                      BoxShadow(
                          offset: Offset(-0.1, 0.1),
                          color: Colors.grey[400],
                          spreadRadius: 0.5,
                          blurRadius: 3
                      )
                    ]
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                    child: TextField(
                      controller: _textController,
                      focusNode: _textNode,
                      decoration: InputDecoration(
                          icon: _userAvatar(users: users, indexName: indexName),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Visibility(
                                  visible: _isEditingContent,
                                  child: IconButton(
                                    icon: Icon(Icons.cancel, color: Colors.grey[400],),
                                    onPressed: (){
                                      setState(() {
                                        _isEditingContent = false;
                                        _textController.text = '';
                                        _textNode.unfocus();
                                      });
                                    },
                                  )
                              ),
                              IconButton(
                                icon: Icon(Icons.send, color: Colors.grey[400],),
                                onPressed: (){
                                  if(_textController.text != null && _textController.text != ''){
                                    if(!_isEditingContent){
                                      print('object');
                                      FirestoreService().addComment(uid: userRole[0].uid, id:  widget.message['content']['data']['docId'], message: _textController.text,visible: true);
                                      setState(() {
                                        _textController.text = '';
                                        _isEditingContent = false;
                                        _textNode.unfocus();
                                      });
                                    }else{
                                      FirestoreService().updateComment(id:  widget.message['content']['data']['docId'], message: _textController.text, docId: _editingIndex).then((value){
                                        Widgets().snackBar(scaffoldGlobalKey: scaffoldGlobalKey,message: 'Comentario actualizado.', textColor: Colors.white.withOpacity(0.8), color: Colors.black.withOpacity(0.8));
                                      }).catchError((error){
                                        Widgets().snackBar(scaffoldGlobalKey: scaffoldGlobalKey,message: 'Se ha presentado un error, intente de nuevo mas tarde.', textColor: Colors.white.withOpacity(0.8), color: Colors.black.withOpacity(0.8));
                                      });
                                      _textController.text = '';
                                      _isEditingContent = false;
                                      _textNode.unfocus();
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                          hintText: 'Comentar',
                          hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600,
                              fontSize: 16
                          ),
                          border: InputBorder.none
                      ),
                      maxLines: 10,
                      minLines: 1,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                      ),
                    )
                ),
              ),
            ),

          ],
        )
            : message()
    );
  }
  //TODO: sin contenido
  Widget message(){
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.cancel,
            color: //Colors.black38.withOpacity(0.2),
            Colors.grey[400],
            size: 100,),
          SizedBox(height: 5,),
          Text(
            'El contenido ya no es accesible.',
            style: TextStyle(
                color://Colors.black38.withOpacity(0.2),
                Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.w700
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
              Container(
                width: 45,
                height: 45,
                child: Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red),backgroundColor: Colors.grey[850],strokeWidth: 3, value: downloadProgress.progress,),
                ),
              ),
          placeholder: (context, url){
            return Container(
              width: 45,
              height: 45,
              child: Container(child: CircularProgressIndicator()),
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

  //TODO: textStyle
  TextStyle _textStyle({size}){
    return TextStyle(
        color: //Colors.white,
        Colors.grey[900],
        fontSize: size,
        fontFamily: 'Glenn Slab'
    );
  }

  Widget setImage({path, height}){
    if(path.length ==1)
      return _oneImage(path: path, height: height);
    if(path.length == 2)
      return _twoImages(path: path, height: height);
    if(path.length == 3)
      return _threeImages(path: path);
    if(path.length > 3)
      return _fourImages(path: path);
  }

  //TODO: image builders
  Widget _oneImage({path, height}){
    return CachedNetworkImage(
      imageUrl: path[0],
      filterQuality: FilterQuality.high,
      placeholder: (context, url){
        return Container(
          height: 250,
          child: Container(height: 40,child: CircularProgressIndicator()),
        );
      },
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          Container(
            height: 250,
            child: Center(
              child: Container(height: 40,child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red),backgroundColor: Colors.grey[850],strokeWidth: 3, value: downloadProgress.progress,),),
            ),
          ),
      imageBuilder: (context, url){
        return InkWell(
          onTap: (){
            Navigator.push(context, FadePageRoute(builder: (context) => GalleryPhotoViewWrapper(
              galleryItems: path,
              scrollDirection: Axis.horizontal,
              backgroundDecoration: BoxDecoration(
                  color: Colors.black
              ),
              initialIndex: 0,
              maxScale: 0.8,
              minScale: 0.4,
              create: false,
            )));
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth:MediaQuery.of(context).size.width,
              maxHeight: 500,
              minWidth:MediaQuery.of(context).size.width,
            ),
            child: Hero(
              tag: path[0],
              child: Image(
                image: url,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _twoImages({path, height}){
    return Container(
      height: 444.4,
      child: Column(
        children: <Widget>[
          _cachedImage(height: 222.2, width: MediaQuery.of(context).size.width, index: 0, file: path,padding: EdgeInsets.only(bottom: 1),fouImages: false),
          _cachedImage(height: 222.2, width: MediaQuery.of(context).size.width, index: 1, file: path,padding: EdgeInsets.only(top: 1),fouImages: false),
        ],
      ),
    );
  }
  Widget _threeImages({path}){
    return Column(
      children: <Widget>[
        _cachedImage(height: 222.2, width: MediaQuery.of(context).size.width, index: 0, file: path,padding: EdgeInsets.all(0),fouImages: false),
        Row(
          children: <Widget>[
            _cachedImage(height: MediaQuery.of(context).size.width/2, width: MediaQuery.of(context).size.width/2, index: 1, file: path, padding: EdgeInsets.only(top: 2,right: 1),fouImages: false),
            _cachedImage(height: MediaQuery.of(context).size.width/2, width: MediaQuery.of(context).size.width/2, index: 2, file: path,padding: EdgeInsets.only(top: 2,left: 1),fouImages: false),
          ],
        ),
      ],
    );
  }
  Widget _fourImages({path}){
    return Column(
      children: <Widget>[
        _cachedImage(height: 222.2, width: MediaQuery.of(context).size.width, index: 0, file: path, padding: EdgeInsets.all((0)),fouImages: false),
        Row(
          children: <Widget>[
            _cachedImage(height: MediaQuery.of(context).size.width/3, width: MediaQuery.of(context).size.width/3, index: 1, file: path, padding: EdgeInsets.only(top: 2,right: 1),fouImages: false),
            _cachedImage(height: MediaQuery.of(context).size.width/3, width: MediaQuery.of(context).size.width/3, index: 2, file: path, padding:EdgeInsets.only(top: 2,right: 1,left: 1), fouImages: false),
            _cachedImage(height: MediaQuery.of(context).size.width/3, width: MediaQuery.of(context).size.width/3, index: 3, file: path, padding:EdgeInsets.only(top: 2,left: 1), fouImages: true),
          ],
        ),
      ],
    );
  }
  Widget _cachedImage({height, width, file, index, padding, fouImages}){
    return CachedNetworkImage(
      imageUrl: file[index],
      filterQuality: FilterQuality.high,
      placeholder: (context, url){
        return Container(
            height: height,
            width: width,
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              ),
            ));
      },
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          Container(
            width: width,
            height: height,
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red),backgroundColor: Colors.grey[850],strokeWidth: 3, value: downloadProgress.progress,),),
            ),
          ),
      imageBuilder: (context, url){
        return InkWell(
          onTap: (){
            Navigator.push(context, FadePageRoute(builder: (context) => GalleryPhotoViewWrapper(
              galleryItems: file,
              scrollDirection: Axis.horizontal,
              backgroundDecoration: BoxDecoration(
                  color: Colors.black
              ),
              initialIndex: index,
              maxScale: 0.8,
              minScale: 0.4,
              create: false,
            )));
          },
          child: Hero(
            tag: file[index],
            child: Container(
                padding: padding,
                width: width,
                height: height,
                child: fouImages ? Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: url,
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    if(file.length >4)
                      Material(
                        color: Colors.transparent,
                        child: Container(
                          height: height,
                          width: width,
                          color: Colors.black.withOpacity(0.35),
                          child: Center(
                            child: Text(
                              '+${file.length - 4}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ): Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: url,
                          fit: BoxFit.cover
                      )
                  ),
                )
            ),
          ),
        );
      },
    );
  }
  //TODO admin bottomSheet
  void adminSheet({context, docId, galleryPath, galleryCount, index, uid, content}){
    final user = Provider.of<List<User>>(context, listen: false);
    _textNode.unfocus();
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
              height: 200.1,
              decoration: BoxDecoration(
                color: //Colors.grey[200],
                Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 8),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                              color: //Colors.grey[300]
                              Colors.grey[600],
                              borderRadius: BorderRadius.circular(10)
                          ),
                        )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20,top: 40,left: 10,right: 10),
                    child: Column(
                      children: <Widget>[
                        adminContainer(title: 'Eliminar comentario', icon: Icons.delete, onTap: () async{
                          print('eli comentario');
                          FirestoreService().deleteComment(id: widget.message['content']['data']['docId'], docId: docId).then((value){
                            Widgets().snackBar(scaffoldGlobalKey: scaffoldGlobalKey,message: 'Comentario eliminado.', textColor: Colors.black.withOpacity(0.8), color: Colors.white.withOpacity(0.8));
                            Navigator.of(context).pop();
                          }).catchError((error){
                            Widgets().snackBar(scaffoldGlobalKey: scaffoldGlobalKey,message: 'Se ha presentado un error, intente de nuevo mas tarde.', textColor: Colors.black.withOpacity(0.8), color: Colors.white.withOpacity(0.8));
                          });

                        }),
                        Visibility(
                          visible: user[0].uid == uid,
                          child: adminContainer(title: 'Actualizar comentario', icon: Icons.edit, onTap: (){
                            print('edit comentario');
                            setState(() {
                              _isEditingContent = true;
                              _textController.text = content;
                              _editingIndex = docId;
                            });
                            Navigator.of(context).pop();
                          }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
  adminContainer({title, onTap, icon}){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.grey[300],size: 25,),
        title: Text(
          title,
          style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
              fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}
