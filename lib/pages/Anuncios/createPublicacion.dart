import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/models/AnuncioModel.dart';
import 'package:ragapp/models/userModel.dart';
import 'package:ragapp/provider/userImageCropperProvider.dart';
import 'package:ragapp/utils/CroppedSettings.dart';
import 'package:ragapp/utils/Widgets/MarkDown/MarkDownTextInput.dart';
import 'package:ragapp/utils/Widgets/AnimatedPageRoute/MaterialFadeTransition.dart';
import 'package:ragapp/utils/Widgets/Gallery/gallery.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class CreatePublicacion extends StatefulWidget {
  final isEditing;
  final docId;
  final index;
  final uid;
  final content;
  CreatePublicacion({this.isEditing, this.docId, this.index, this.uid, this.content});
  @override
  _CreatePublicacionState createState() => _CreatePublicacionState();
}

class _CreatePublicacionState extends State<CreatePublicacion> with SingleTickerProviderStateMixin{
  //TODO: controllers
  TabController _tabBarController;
  TextEditingController _contentController = TextEditingController();
  TextEditingController _singleImageController = TextEditingController();
  //TODO: Global keys
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  GlobalKey _containerSize = GlobalKey();
  //TODO: variables
  String _content;
  List<File> _path;
  File croppedFile;
  File multiCroppedFile;
  List<String> _usersID = [];
  var indexName;

  //TODO: instances
  final picker = ImagePicker();
  FirestoreService _firestoreService = FirestoreService();
  Widgets _widgets = Widgets();



  //TODO: OPEN LINKS ON ANOTHER APP
  _launchURL(url) async {
    print('launch url!');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabBarController = TabController(length: 2, vsync: this);
    if(widget.isEditing){
      _content = widget.content;
      _contentController.text = widget.content;
    }else{
      _content = '';
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  //TODO: onbackPressed
  Future<bool> response(){
    return _widgets.onBackPressedWithRoute(
        dismissible: true,
        context: context,
        title: widget.isEditing ? 'Cancelar Actualización' :'Cancelar Creación',
        fontSize: 13,
        message: widget.isEditing ? 'Está seguro? No se aplicará niungún cambio' :'Está seguro? No se crearaá ningún documento',
        singOut: false,
        route: null
    );
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<List<User>>(context);
    final publicacion = Provider.of<List<Publicaciones>>(context);
    final users = Provider.of<List>(context);
       if(widget.isEditing && widget.docId == publicacion[widget.index].id){
      setState(() {
        _usersID.clear();
        for(int i = 0; i <= users.length -1; i++){
          _usersID.add(users[i].uid);
        }
        indexName = _usersID.indexOf(widget.uid);
      });
    }
    return WillPopScope(
      onWillPop: response,
      child:  Scaffold(
        backgroundColor: Colors.grey[350],
        key: scaffoldGlobalKey,
        //Colors.white,
        appBar: AppBar(
          backgroundColor: //Colors.white,
          Colors.grey[900],
          centerTitle: false,
          titleSpacing: 0,
          title: Text(
            widget.isEditing ? 'Actualizar Pulicación' : 'Crear Publicación',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: //Colors.black
                Colors.white
            ),
          ),
          leading: InkWell(
              onTap: () async{
                var res = await response();
                if(res){
                  Navigator.of(context).pop(res);
                }
              },
              child: Icon(
                  Icons.arrow_back_ios,
                  color: //Colors.black
                  Colors.white
              )
          ),
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
          bottom: TabBar(
            controller: _tabBarController,
            indicatorColor: Colors.red,
            tabs: <Widget>[
              Tab(
                  child: Text(
                    'Editor',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: //Colors.black
                        Colors.white
                    ),
                  )
              ),
              Tab(
                  child: Text(
                    'Pre Visualización',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: //Colors.black
                        Colors.white
                    ),
                  )
              )
            ],
          ),
        ),
        //TODO: body
        body: TabBarView(
          controller: _tabBarController,
          children: <Widget>[
            _editor(),
            _preView(userIndex: indexName)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            if(widget.isEditing){
              if((_content != null && _content != '') || (_contentController.text != null && _contentController.text != '') || (_path != null)){
                _firestoreService.updatePublicacion(
                  context: context,
                  docId: widget.docId,
                  content: _content,
                  listImages: _path != null ? _path : null,
                  galleryImageName: publicacion[widget.index].galleryIndexName,
                  galleryUrl: publicacion[widget.index].gallery,
                  nameLength: publicacion[widget.index].galleryIndexName != null ? publicacion[widget.index].galleryIndexName.length : null,
                  imagesLength: _path != null ? _path.length : null,
                );
              }else{
                _widgets.snackBar(
                    scaffoldGlobalKey: scaffoldGlobalKey,
                    color: Colors.black.withOpacity(0.8),
                    textColor: Colors.white.withOpacity(0.8),
                    message: 'Llene los campos para continuar'
                );
              }
            }else{
              if((_content != null && _content != '') || (_contentController.text != null && _contentController.text != '') || (_path != null)){
                _firestoreService.createPublicacion(
                  size: '0',
                  publishedDate: DateTime.now().toString(),
                  context: context,
                  imagesLength: _path != null ? _path.length : null,
                  listImages: _path != null ? _path : null,
                  dateEvent: DateTime.now().toString(),
                  content: _content != null && _content != '' ? _content : '',
                  userId: user[0].uid,
                ).then((value){
                });
              }else{
                _widgets.snackBar(
                  scaffoldGlobalKey: scaffoldGlobalKey,
                  color: Colors.black.withOpacity(0.8),
                  textColor: Colors.white.withOpacity(0.8),
                  message: 'Llene los campos para continuar'
                );
              }
            }
          },
          child: Icon(Icons.check),
        ),
      ),
    );
  }

  Widget _editor(){
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: MarkdownTextInput(
                  (String value) => setState(() => _content = value),
              _content,
              label: 'Description',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if(widget.isEditing)
                    Text(
                      'Imagenes subidas\n(No se mostrarán en la Pre visualización)',
                      style: TextStyle(
                          color: //Colors.grey[300],
                          Colors.grey[900],
                          fontSize: 12,
                          fontFamily: 'Glenn Slab'
                      ),
                    ),
                    storageGrid(),
                  Text(
                    'Galeria',
                    style: TextStyle(
                        color: //Colors.grey[300],
                        Colors.grey[900],
                        fontSize: 12,
                        fontFamily: 'Glenn Slab'
                    ),
                  ),
                  gridImages()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _preView({userIndex}){
    final user = Provider.of<List<User>>(context);
    final users = Provider.of<List>(context);
    return Container(
      padding: EdgeInsets.only(top: 15),
      height: 200,
      width: 600,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                //Colors.grey[900],
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
                              CachedNetworkImage(
                                imageUrl: widget.isEditing ? users[userIndex].photoUrl : user[0].photoUrl,
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
                                        )
                                    ),
                                  );
                                },
                              ),
                              /**/
                              SizedBox(width: 10,),
                              Container(
                                height: 40,
                                child:  Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      user[0].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.3,
                                          wordSpacing: -0.3,
                                          fontSize: 13,
                                          color: Colors.grey[900]
                                          //Colors.white
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      timeago.format(DateTime.now(),locale: 'en_short'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.3,
                                          wordSpacing: -0.3,
                                          fontSize: 10.5,
                                          color: Colors.grey[500],
                                          //Colors.grey[500]
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            height: 45,
                            child: Icon(
                                Icons.more_vert,
                                size: 20,
                              color: Colors.grey[900],
                            //Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: _content != null && _content!= '' ? EdgeInsets.only(right: 15, left: 15, top: 0, bottom: 15) : EdgeInsets.all(0),
                      child: MarkdownBody(
                        onTapLink: (link){
                          print('object => $link');
                          _launchURL(link);
                        },
                        data: _content,
                        styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
                        styleSheet: MarkdownStyleSheet(
                          p: _textStyle(size: 15.1),
                          h1: _textStyle(size: 25.1),
                          h2: _textStyle(size: 21.1),
                          h3: _textStyle(size: 17.1),
                          h4: _textStyle(size: 16.1),
                          h5: _textStyle(size: 15.1),
                          h6: _textStyle(size: 14.1),
                          strong: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.w800
                          ),
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
                        ),
                        selectable: false,
                      ),
                    ),
                    SizedBox(height: 0,),
                   Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _path == null ? Container(height: 10,)
                        : _path.length == 0 ? Container(): setImage()
                      ],
                    ),
                    Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width/3,
                              child: Center(
                                child:   Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                        Icons.favorite_border,
                                        color: Colors.grey[900]
                                      //Colors.white
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      'me gusta',
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
                              width: MediaQuery.of(context).size.width/3,
                              child: Center(
                                child:   Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ImageIcon(
                                        AssetImage('icons/comentario.png'),
                                        color: Colors.grey[900]
                                      //Colors.white
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
                              width: MediaQuery.of(context).size.width/3,
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
                          ],
                        )
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }

  Widget setImage(){
    if(_path.length ==1)
      return _oneImage();
    if(_path.length == 2)
      return _twoImages();
    if(_path.length == 3)
      return _threeImages();
    if(_path.length > 3)
      return _fourImages();
  }

  Widget _oneImage(){
    return Container(
      key: _containerSize,
      constraints: BoxConstraints(
        maxWidth:MediaQuery.of(context).size.width,
        maxHeight: 500,
        minWidth:MediaQuery.of(context).size.width,
      ),
      padding: EdgeInsets.only(top: 2,right: 1),
      child: Image.file(_path[0],fit: BoxFit.cover,),
    );
  }

  Widget _twoImages(){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 2,right: 1),
          width: MediaQuery.of(context).size.width,
          height:  222.2,
          child: Image.file(_path[0],fit: BoxFit.cover,),
        ),
        Container(
          padding: EdgeInsets.only(top: 2,right: 1),
          width: MediaQuery.of(context).size.width,
          height: 222.2,
          child: Image.file(_path[1],fit: BoxFit.cover,),
        ),
      ],
    );
  }

  Widget _threeImages(){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 2,right: 1),
          width: MediaQuery.of(context).size.width,
          height:  222.2,
          child: Image.file(_path[0],fit: BoxFit.cover,),
        ),
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 2,right: 1),
              width: MediaQuery.of(context).size.width/2,
              height:  MediaQuery.of(context).size.width/2,
              child: Image.file(_path[1],fit: BoxFit.cover,),
            ),
            Container(
              padding: EdgeInsets.only(top: 2,right: 1,left: 1),
              width:  MediaQuery.of(context).size.width/2,
              height:  MediaQuery.of(context).size.width/2,
              child: Image.file(_path[2],fit: BoxFit.cover,),
            ),
          ],
        ),
      ],
    );
  }

  Widget _fourImages(){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 2,right: 1),
          width: MediaQuery.of(context).size.width,
          height:  222.2,
          child: Image.file(_path[0],fit: BoxFit.cover,),
        ),
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 2,right: 1),
              width: MediaQuery.of(context).size.width/3,
              height:  MediaQuery.of(context).size.width/3,
              child: Image.file(_path[1],fit: BoxFit.cover,),
            ),
            Container(
              padding: EdgeInsets.only(top: 2,right: 1,left: 1),
              width:  MediaQuery.of(context).size.width/3,
              height:  MediaQuery.of(context).size.width/3,
              child: Image.file(_path[2],fit: BoxFit.cover,),
            ),
            Container(
                padding: EdgeInsets.only(top: 2,left: 1),
                width:  MediaQuery.of(context).size.width/3,
                height:  MediaQuery.of(context).size.width/3,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.file(_path[3],fit: BoxFit.cover,),
                    if(_path.length >4)
                      Container(
                        height: MediaQuery.of(context).size.width/3,
                        width: MediaQuery.of(context).size.width/3,
                        color: Colors.black.withOpacity(0.35),
                        child: Center(
                          child: Text(
                            '+${_path.length - 4}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      )
                  ],
                )
            )
          ],
        ),
      ],
    );
  }

  //TODO: network images
  Widget storageGrid(){
    final publicaciones = Provider.of<List<Publicaciones>>(context);
    if(widget.isEditing){
      if(publicaciones[widget.index].gallery != null && publicaciones[widget.index].gallery.toString() != '[]'){
        return SingleChildScrollView(
            child: GridView.count(
              crossAxisCount: 3,
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate( publicaciones[widget.index].gallery.length, (index){
                return  Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Hero(
                    tag: publicaciones[widget.index].gallery[index],
                    child: Material(
                      color: Colors.transparent,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            children: <Widget>[
                              InkWell(
                                  onTap: (){
                                    print('object');
                                    Navigator.push(context, FadePageRoute(builder: (context) => GalleryPhotoViewWrapper(
                                      galleryItems: publicaciones[widget.index].gallery,
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
                                  child: CachedNetworkImage(
                                    imageUrl: publicaciones[widget.index].gallery[index],
                                    filterQuality: FilterQuality.high,
                                    placeholder: (context, url){
                                      return Container(
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(Colors.red),
                                            backgroundColor: Colors.grey[850],
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      );
                                    },
                                    imageBuilder: (context, url){
                                      return Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            image: DecorationImage(
                                                image: url,
                                                fit: BoxFit.cover
                                            )
                                        ),
                                      );
                                    },
                                  )
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5, top: 5),
                                  child: InkWell(
                                    onTap: () async{
                                      //TODO: delete index document
                                      await _firestoreService.deleteAnuncioImage(
                                          docId: widget.docId,
                                          indexImage: publicaciones[widget.index].galleryIndexName[index],
                                          indexUrl: publicaciones[widget.index].gallery[index]
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.red,
                                      ),
                                      height: 22,
                                      width: 22,
                                      child: Icon(Icons.delete, color: Colors.white, size:  15,),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                );
              }),
            )
        );
      }else{
        return Text('');
      }
    }else{
      return Container();
    }

  }
  //TODO: local images
  gridImages(){
    return SingleChildScrollView(
        child: _path != null ? _path.length > 0 ? GridView.count(
          crossAxisCount: 3,
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: List.generate(_path.length+1, (index) {
            return Padding(
                padding: EdgeInsets.all(8.0),
                child: index != _path.length ? Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  elevation: 2,
                  child: Hero(
                    tag: _path[index],
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: //Colors.white,
                          Colors.grey[900],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: <Widget>[
                            InkWell(
                                onTap: (){
                                  Navigator.push(context, FadePageRoute(builder: (context) => GalleryPhotoViewWrapper(
                                    galleryItems: _path,
                                    scrollDirection: Axis.horizontal,
                                    backgroundDecoration: BoxDecoration(
                                        color: Colors.black
                                    ),
                                    initialIndex: index,
                                    maxScale: 0.8,
                                    minScale: 0.4,
                                    create: true,
                                  )));
                                },
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          image: FileImage(
                                            _path[index],
                                          ),
                                          fit: BoxFit.cover
                                      )
                                  ),

                                )
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5, top: 5),
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          _path.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.red,
                                        ),
                                        height: 22,
                                        width: 22,
                                        child: Icon(Icons.delete, color: Colors.white, size:  15,),
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    InkWell(
                                      onTap: (){
                                        _cropImage(
                                            multiImage: true,
                                            index: index,
                                            path: _path
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.red,
                                        ),
                                        height: 22,
                                        width: 22,
                                        child: Icon(Icons.crop, color: Colors.white, size:  15,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ) :pathImages(addMore: true)
            );
          }),
        ) : pathImages(addMore: false)
            : pathImages(addMore: false)
    );
  }
  //TODO: add images
  Widget pathImages({addMore}){
    return Padding(
        padding: addMore ? EdgeInsets.all(0) :EdgeInsets.only(left: 0, top: 10, bottom: 30),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () async{
            await getFilePath();
          },
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(15),
            color: Colors.transparent,
            child: Container(
              height: 117,
              width: 117,
              decoration: BoxDecoration(
                  color: Colors.white,
                  //Colors.grey[900],
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.add, color: Colors.grey[400], size: 35,
                    ),
                    Text(
                      'Agregar Album',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 11,
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
  //TODO: get multi images
  Future getFilePath() async {
    List<File> extension;
    try {
      extension = await FilePicker.getMultiFile(
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg']);
      if (extension == null) {
      }
      else
      {
        setState(() {
          if(_path != null){
            for(int i=0; i< extension.length; i++){
              if(_path.isNotEmpty){
                if(_path[i].path == extension[i].path){
                  print('ya existe');
                }else{
                  print('No existe');
                  _path.add(extension[i]);
                }
              }else{
                _path = extension;
              }
            }
          }else{
            _path = extension;
          }
        });
      }

    } on PlatformException catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }
  //TODO: single image
  Future chooseImage() async{
    final _imageProvider = Provider.of<UserImageProvider>(context, listen: false);
    final _image = await picker.getImage(source: ImageSource.gallery);
    if( _image != null){
      setState(() {
        _imageProvider.setFile(File(_image.path));
      });
    }
    if(_imageProvider.pathImage != null){
      _cropImage(multiImage: false);
    }else{
      print('error al cargar la imagen');
    }
  }
  //TODO: recortar imagen
  Future _cropImage({multiImage, index, path}) async {
    final _image = Provider.of<UserImageProvider>(context, listen: false);
    if(multiImage){
      multiCroppedFile = await CroppedSettings().cropImage(context: context,image: path[index].path);
      if(multiCroppedFile != null) {
        setState(() {
          _path.removeAt(index);
          _path.insert(index, multiCroppedFile);
          _singleImageController.text = '';
        });
      }
    }else{
      croppedFile = await CroppedSettings().cropImage(context: context,image: _image.pathImage.path);
      if (croppedFile != null) {
        setState(() {
          _image.setFile(croppedFile);
          _singleImageController.text = croppedFile.path;
        });
      }
    }
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
}