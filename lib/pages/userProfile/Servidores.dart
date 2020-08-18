import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/models/MinisterioModel.dart';
import 'package:ragapp/models/userModel.dart';
import 'package:ragapp/pages/userProfile/userDetailPage.dart';
import 'package:ragapp/provider/userImageCropperProvider.dart';
import 'package:ragapp/utils/Widgets/AnimatedPageRoute/MaterialFadeTransition.dart';
import 'package:ragapp/utils/Widgets/CustomDialog.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';

class Servidores extends StatefulWidget {
  @override
  _ServidoresState createState() => _ServidoresState();
}

class _ServidoresState extends State<Servidores> with TickerProviderStateMixin{
  //TODO: global keys
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  //TODO: variables
  String searchString;
  String searchByMinisterio;
  File croppedFile;
  var selectedIndex;
  //TODO: instances
  FirestoreService _firestoreService = FirestoreService();
  Widgets _widgets = Widgets();
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firestoreService.closeMinisteriosStream();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: variables
    List<String> _nameDb = [];
    List<String> _iconDb = [];
    List<String> _currentMinisterio =[];

    var _size = MediaQuery.of(context).size;
    var ministerio = Provider.of<List<Ministerio>>(context);
    final userRole = Provider.of<List<User>>(context);

    return StreamBuilder(
      stream: _firestoreService.SearchUser(searchIndex: searchString, searchByMinisterio: searchByMinisterio, isService: true, isAdmin: false),
      builder: (context, snapshot){
        _iconDb.clear();
        _currentMinisterio.clear();
        _nameDb.clear();
        if(ministerio != null){
          for(int i = 0; i <= ministerio.length-1; i++){
            _currentMinisterio.add(ministerio[i].id);
            _nameDb.add(ministerio[i].name);
            _iconDb.add(ministerio[i].imageUrl);
            _nameDb[i] = ministerio[i].name;
            _iconDb[i] = ministerio[i].imageUrl;
          }
        }else{

        }
        return Scaffold(
          key: scaffoldGlobalKey,
          backgroundColor: Colors.grey[200],
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                centerTitle: false,
                leading: Visibility(
                  visible: true,
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Visibility(
                      visible: userRole[0].isAdmin,
                      child: InkWell(
                        onTap: () async{
                          await changePhoto();
                        },
                        child: Icon(Icons.camera_alt),
                      ),
                    ),
                  ),
                ],
                expandedHeight: _size.height / 3.8,
                backgroundColor: Colors.grey[850],
                pinned: true,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(left: 50, bottom: 16),
                  title: Text(
                    'Servidores',
                    style: TextStyle(
                        fontFamily: 'Glenn Slab',
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  centerTitle: false,
                  background: StreamBuilder(
                    stream: _firestoreService.banner(),
                    builder: (context, snapshot){
                      return CachedNetworkImage(
                        imageUrl: snapshot.data != null ? snapshot.data[0].imageUrl : '',
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            Center(
                              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red),backgroundColor: Colors.grey[850],strokeWidth: 3, value: downloadProgress.progress,),
                            ),
                        filterQuality: FilterQuality.high,
                        imageBuilder: (context, image){
                          return  Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: image,
                                  fit: BoxFit.cover,
                                )
                            ),
                          );
                        },
                      );
                    },
                  )
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index){
                    return Column(
                      children: <Widget>[
                        //TODO: btn buscar
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                            child: Container(
                              width: _size.width,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[300],
                                        offset: Offset(0,-1),
                                        spreadRadius: 0.8,
                                        blurRadius: 10
                                    ),
                                    BoxShadow(
                                        color: Colors.grey[400],
                                        offset: Offset(-0.4,1),
                                        spreadRadius: 0.8,
                                        blurRadius: 3
                                    )
                                  ]
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: 0,right: 10,left: 10, bottom: 0),
                                child: TextFormField(
                                  onChanged: (value){
                                    setState(() {
                                      searchString = value.toLowerCase();
                                    });
                                  },
                                  decoration: InputDecoration(
                                      icon: Padding(
                                        padding: const EdgeInsets.only(bottom: 0, left: 5),
                                        child: Icon(Icons.search, color: Colors.grey[850],),
                                      ),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(bottom: 0, right: 5),
                                        child: Icon(Icons.sort, color: Colors.grey[850],),

                                      ),
                                      border: InputBorder.none,
                                      suffixText: 'Filtrar',
                                      hintText: 'Buscar',
                                      hintStyle: TextStyle(
                                          fontFamily: 'Glenn Slab'
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //TODO: ministerios
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10,left: 8, right: 8),
                          child: Container(
                            width: _size.width,
                            height: 35,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: ministerio != null ? ministerio.length : 0,
                              itemBuilder: (context, index){
                                return Row(
                                  children: <Widget>[
                                    Visibility(
                                        visible:true,
                                        child: InkWell(
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          onTap: (){
                                            setState(() {
                                              selectedIndex = index;
                                              searchByMinisterio = ministerio[index].id;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.black38,
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                ImageIcon(
                                                  NetworkImage(ministerio[index].imageUrl),
                                                  size: 18,
                                                  color: Colors.white,
                                                ),//Icon(Icons.people, color: Colors.white, size: 20,)
                                                SizedBox(width: 8,),
                                                Text(
                                                  ministerio[index].name,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Glenn Slab'
                                                  ),
                                                ),
                                                SizedBox(width: 3,),
                                                Visibility(
                                                    visible: selectedIndex == index ? true : false,
                                                    child: InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                          searchByMinisterio = null;
                                                          selectedIndex = null;
                                                        });
                                                      },
                                                      child: Icon(Icons.cancel, color: Colors.white, size: 18,),
                                                    )
                                                )
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
                      ],
                    );
                  },
                      childCount: 1
                  ),
                ),
              ),
              SliverPadding(
                  padding: EdgeInsets.only(bottom: 10),
                  sliver: snapshot.data != null && snapshot.data.toString() != '[]' ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: _size.aspectRatio >= 0.46 && _size.aspectRatio < 0.6 ? _size.aspectRatio * 1.55 : _size.aspectRatio * 1.5,),
                    delegate: SliverChildBuilderDelegate((context, index){
                      if(snapshot.data != null){
                        return Hero(
                          tag: snapshot.data[index].uid,
                          child: Material(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, FadePageRoute(builder: (context) => userDetailPage(documentId: snapshot.data[index].uid, servidores: true,)));
                                },
                                child: _widgets.userCard(
                                    snapshot: snapshot,
                                    size: _size,
                                    ministerio: ministerio,
                                    currentMinisterio: _currentMinisterio,
                                    index: index,
                                    isService: true
                                ),
                              ),
                            ),
                          ),
                        );
                      }else{
                        return Container();
                      }
                    }, childCount: snapshot.data == null ? 0 : snapshot.data.length),
                  )
                      : SliverToBoxAdapter(
                    child: Container(
                      height: 350,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.error_outline, color: Colors.black38.withOpacity(0.2),size: 100,),
                            SizedBox(height: 5,),
                            Text(
                              'Sin resultados',
                              style: TextStyle(
                                  color: Colors.black38.withOpacity(0.2),
                                  fontSize: 15
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
              )
            ],
          ),
        );
      },
    );
  }

  //TODO: change profile photo
  //TODO: subir foto
  Future changePhoto()async{
    final _imageProvider = Provider.of<UserImageProvider>(context, listen: false);
    //TODO variables
    final _image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if(_image != null){
        _imageProvider.setFile(File(_image.path));
      }
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
          StorageReference storageReference = FirebaseStorage().ref().child('utils');
          //TODO: uploadtask
          await pr.show();
          Future.delayed(Duration(milliseconds: 2000)).then((value) async{
            StorageUploadTask uploadTask = storageReference.child('mWm7w5RO3XCfCFArqzIE').putFile(croppedFile);
            if(uploadTask != null){
              if(uploadTask.isInProgress){
                //TODO: show progressbar
                await pr.show();
              }else if(uploadTask.isSuccessful){
                Future.delayed(Duration(milliseconds: 100));
                await pr.hide();
              }
            }else{
              setState(() {
                _imageProvider.setFile(File('null'));
              });
              _widgets.snackBar(message: 'No se pudo cambiar el banner.', scaffoldGlobalKey: scaffoldGlobalKey, color: Colors.black, textColor: Colors.white.withOpacity(0.92));
            }
            //TODO: on complete task
            await uploadTask.onComplete.then((storageTask) async{
              //TODO: get url image
              String _link = await storageTask.ref.getDownloadURL();
              print(_link);
              //TODO: update user data
              var response = await _firestoreService.updateServidorBanner(link: _link);
              if(response){
                Future.delayed(Duration(milliseconds: 2000));
                await pr.hide();
                setState(() {
                  _imageProvider.setFile(File('null'));
                });
                _widgets.snackBar(message: 'Se ha cambiado el banner correctamente.', scaffoldGlobalKey: scaffoldGlobalKey, color: Colors.black, textColor: Colors.white.withOpacity(0.92));
              }else{
                setState(() {
                  _imageProvider.setFile(File('null'));
                });
                Future.delayed(Duration(milliseconds: 2000));
                await pr.hide();
                _widgets.snackBar(message: 'No se pudo cambiar el banner.', scaffoldGlobalKey: scaffoldGlobalKey, color: Colors.black, textColor: Colors.white.withOpacity(0.92));
              }
            });
          });
        }else{
          setState(() {
            _imageProvider.setFile(File('null'));
          });
          Future.delayed(Duration(milliseconds: 2000));
          await pr.hide();
          _widgets.snackBar(message: 'No se pudo cambiar el banner.', scaffoldGlobalKey: scaffoldGlobalKey, color: Colors.black, textColor: Colors.white.withOpacity(0.92));
        }
      });
    }else{
      setState(() {
        _imageProvider.setFile(File('null'));
      });
      _widgets.snackBar(message: 'No se pudo cambiar el banner.', scaffoldGlobalKey: scaffoldGlobalKey, color: Colors.black, textColor: Colors.white.withOpacity(0.92));
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
}
