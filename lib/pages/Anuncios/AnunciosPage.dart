import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/Services/sendNotification.dart';
import 'package:ragapp/models/AnuncioModel.dart';
import 'package:ragapp/models/userModel.dart';
import 'package:ragapp/pages/Anuncios/Comment.dart';
import 'package:ragapp/pages/Anuncios/createPublicacion.dart';
import 'package:ragapp/provider/deleteAnuncioProvider.dart';
import 'package:ragapp/utils/Widgets/AnimatedPageRoute/MaterialFadeTransition.dart';
import 'package:ragapp/utils/Widgets/Gallery/gallery.dart';
import 'package:ragapp/utils/Widgets/publicacionesWidgets/publicacionesBuilders.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class TopScrollScreenEffect extends StatefulWidget {
  @override
  _TopScrollScreenEffectState createState() => _TopScrollScreenEffectState();
}

class _TopScrollScreenEffectState extends State<TopScrollScreenEffect> {
  //TODO: global keys
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  //TODO: objetos
  FirestoreService _firestoreService = FirestoreService();
  Widgets _widgets = Widgets();
  CustomBuilders _customBuilders = CustomBuilders();
  //TODO: controller


  //TODO: variables
  List<String> _usersID = [];

  List<String> _likeUsers = [];
  List<String> _likeID = [];
  List<String> _usersName = [];
  List<String> _usersPhoto = [];

  _launchURL(url) async {
    print('launch url!');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onListen(){
    setState(() {
    });
  }
  Future<bool> response(){
    return _widgets.onBackPressedWithRoute(
        dismissible: true,
        context: context,
        title: 'Eliminar Anuncio',
        fontSize: 13,
        message: 'Esta seguro de eliminar este anuncio? No se podrán recuperar los datos',
        singOut: false,
        route: null
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('bye AnunciosPage');
  }
  @override
  Widget build(BuildContext context) {
    //TODO: screen size
    var _size = MediaQuery.of(context).size;
    //TODO call provider
    final snapshot = Provider.of<List<Publicaciones>>(context);
    final delete = Provider.of<DeleteAnuncioProvider>(context);
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
        //Colors.black,
        appBar: AppBar(
          backgroundColor: //Colors.white,
          Colors.grey[900],
          centerTitle: false,
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
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            StreamBuilder<bool>(
              initialData: false,
              stream: delete.stream,
              builder: (context, delete){
                if(delete.data){
                  WidgetsBinding.instance.addPostFrameCallback((_) => _widgets.onDelete(
                      context: context,
                      title: 'Eliminado',
                      fontSize: 25,
                      message: 'Anuncio eliminado correctamente',
                      route: null,
                      dismissible: false,
                      singOut: false));
                }

                return Container(
                    height: Platform.isIOS && (MediaQuery.of(context).size.height == 812 || MediaQuery.of(context).size.height == 896) ? _size.height * 0.85 : _size.height * 0.82,
                    child: snapshot!= null ? snapshot.length !=0 ? ListView.builder(
                      itemCount: snapshot.length,
                      itemBuilder: (context, index){
                        var indexName = _usersID.indexOf(snapshot[index].publishedBy);
                        return Padding(
                          padding: index+1 == snapshot.length ? EdgeInsets.only(top: 7,bottom: 70) :EdgeInsets.symmetric(vertical: 7),
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
                              //Colors.grey[900],
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
                                                        timeago.format(DateTime.parse(snapshot[index].publishedDate,),locale: 'en_short'),
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
                                        Visibility(
                                          visible: userRole !=null ? userRole[0].isAdmin : false,
                                          child: InkWell(
                                            onTap: (){

                                              if(snapshot[index].gallery == []){

                                              }else{
                                                print('================${snapshot[index].gallery.length}');
                                              }
                                              adminSheet(
                                                  context: context,
                                                  galleryCount: snapshot[index].gallery != null ? snapshot[index].gallery.length : null,
                                                  galleryPath: snapshot[index].gallery.length != 0 ? snapshot[index].galleryIndexName : null,
                                                  docId: snapshot[index].id,
                                                  index: index,
                                                  content: snapshot[index].content,
                                                  uid: users[indexName].uid
                                              );
                                            },
                                            child: Container(
                                              alignment: Alignment.topRight,
                                              height: 45,
                                              width: 30,
                                              child: Icon(
                                                  Icons.more_vert,
                                                  size: 20
                                                  ,color: Colors.grey[900],
                                              //Colors.white
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  //TODO: content
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: snapshot[index].content != null && snapshot[index].content != '' ? EdgeInsets.only(right: 15, left: 15, top: 0, bottom: 15) : EdgeInsets.all(0),
                                    child: MarkdownBody(
                                      onTapLink: (link){
                                        _launchURL(link);
                                      },
                                      data: snapshot[index].content,
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
                                      snapshot[index].gallery == null ? Container()
                                          :  snapshot[index].gallery.length == 0 ? Container():
                                      setImage(path: snapshot[index].gallery, height: snapshot[index].heightSize)
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
                                                stream: _firestoreService.likeCount(id: snapshot[index].id),
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
                                                          index: index,
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
                                              child:   //TODO: comments builder
                                              StreamProvider<List<Comments>>.value(
                                                value: _firestoreService.viewComment(id: snapshot[index].id),
                                                child: Builder(
                                                  builder: (context){
                                                    var comments = Provider.of<List<Comments>>(context);
                                                    return InkWell(
                                                      onTap: (){
                                                        commentSheet(context: context,users: users,indexName: indexName, stream: comments, docId: snapshot[index].id, usersId: _usersID, likeCount: _likeID.length.toString());
                                                      },
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
                                                    );
                                                  },
                                                ),
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
                                  )
                                ],
                              )
                          ),
                        );
                      },
                    ) : message()
                        : message()
                );
              },
            )
          ],
        )
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

  //TODO: textStyle
  TextStyle _textStyle({size}){
    return TextStyle(
        color: //Colors.white,
        Colors.grey[900],
        fontSize: size,
        fontFamily: 'Glenn Slab'
    );
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
            'No hay contenido en este momento',
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

  //TODO: commets screen
  void commentSheet({context, users, indexName, stream, docId, usersId, likeCount}){
    showModalBottomSheet(
        context: context,
        backgroundColor: //Colors.grey[300,
        Colors.grey[200],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        elevation: 10,
        builder: (context) => Container(
            constraints: BoxConstraints(
                maxHeight:  MediaQuery.of(context).size.height - ScreenUtil.statusBarHeight
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: StatefulBuilder(
              builder: (context, setState){
                return CommentPage(indexName: indexName,docId: docId, usersId: usersId, likeCount: likeCount,);
              },
            )
        )
    );
  }

  //TODO admin bottomSheet
  void adminSheet({context, docId, galleryPath, galleryCount, index, uid, content}){
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
              height: 260.1,
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
                        adminContainer(title: 'Eliminar publicación', icon: Icons.delete, onTap: () async{
                          var res = await response();
                          if(res){
                            _firestoreService.deletePublicacion(
                                context: context,
                                docId: docId,
                                galleryPath: galleryPath,
                                galleryCount: galleryCount
                            );
                          }
                        }),
                        adminContainer(title: 'Actualizar publicación', icon: Icons.edit, onTap: (){
                          Navigator.push(context, FadePageRoute(builder: (context) => CreatePublicacion(
                            docId: docId,
                            index: index,
                            uid: uid,
                            isEditing: true,
                            content: content,
                          )));
                        }),
                        adminContainer(title: 'Enviar notificación', icon: Icons.add_alert, onTap: (){
                          Navigator.pop(context);
                          postNotification().sendNotificationOnBackground(
                            uid: uid,
                            image: null,
                            url: null,
                            body: 'Ya viste esta publicacioón?',
                            hasUrl: false,
                            isPost: true,
                            docId: docId,
                            title: 'Recordatorio'
                          );
                        })
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