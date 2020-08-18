import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/sendNotification.dart';
import 'package:ragapp/models/AnuncioModel.dart';
import 'package:ragapp/models/ListContentModel.dart';
import 'package:ragapp/models/MinisterioModel.dart';
import 'package:ragapp/models/bannerModel.dart';
import 'package:ragapp/models/channelModel.dart';
import 'package:ragapp/models/notificationModel.dart';
import 'package:ragapp/models/userModel.dart';
import 'package:ragapp/models/videoModel.dart';
import 'package:ragapp/pages/userProfile/notifications.dart';
import 'package:ragapp/provider/deleteAnuncioProvider.dart';
import 'package:ragapp/utils/Widgets/CustomDialog.dart';

class FirestoreService{

  //TODO: streamController
  StreamController<List<LikeByUser>> _likeCountStreamController = StreamController<List<LikeByUser>>.broadcast();
  StreamController<List<User>> _userStreamController = StreamController<List<User>>.broadcast();
  StreamController<List<Ministerio>> _ministeriostreamController = StreamController<List<Ministerio>>.broadcast();
  StreamController<List<ViewByUser>> _viewCountStreamController = StreamController<List<ViewByUser>>.broadcast();
  StreamController<List<Channel>> _channelDataStreamController = StreamController<List<Channel>>.broadcast();
  StreamController<List<Video>> _videoDataStreamController = StreamController<List<Video>>.broadcast();
  //TODO: instancias
  final CollectionReference _usersCollectionReference =
  Firestore.instance.collection('users');
  final CollectionReference _ministerioCollectionReference =
  Firestore.instance.collection('ministerios');
  final CollectionReference _bannerCollectionReference =
  Firestore.instance.collection('utils');
  final CollectionReference _publicacionesCollectionReference =
  Firestore.instance.collection('publicaciones');
  final CollectionReference _channelCollectionReference =
  Firestore.instance.collection('youtubeChannel');
  final CollectionReference _predicationCollectionReference =
  Firestore.instance.collection('predicaciones');
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future enableministeriosStream() async{
    await _ministeriostreamController.onResume;
  }
  Future closeMinisteriosStream() async{
    await _ministeriostreamController.close();
  }
  Future closeAllStreams() async{
    await _viewCountStreamController.close();
    await _likeCountStreamController.close();
    await _userStreamController.close();
    await _ministeriostreamController.close();
    await _channelDataStreamController.close();
    await _videoDataStreamController.close();
  }


  Future closeConnection() async{
    await _viewCountStreamController.close();
    await _likeCountStreamController.close();
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //TODO: list document of type anuncio / publicaicon
  Stream<List<Publicaciones>> listAllPublicaciones(){
    return _publicacionesCollectionReference.orderBy('publishedDate', descending: true).snapshots()
        .map((update) => update.documents
        .map((snapshot) => snapshot.data != null ? Publicaciones.fromMap(snapshot.data) : null).toList());
  }

  Stream<List<Publicaciones>> listSinglePublicacion({docId}){
    return _publicacionesCollectionReference.where("id", isEqualTo: docId).snapshots()
        .map((update) => update.documents
        .map((snapshot) => snapshot.data != null ? Publicaciones.fromMap(snapshot.data) : null)
        .toList());
  }

  //TODO: create new document of type anuncio / publicacion
  Future createPublicacion({context, listImages, userId, publishedDate, content, size, dateEvent, imagesLength, }) async{
    String message = 'Creando publicación';
    var _docId = await _publicacionesCollectionReference.document().documentID;
    //TODO: lista de imagenes
    //TODO: progressbar
    var pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: false
    );
    pr.style(
      backgroundColor: Colors.white,
      borderRadius: 10,
      elevation: 10,
      progressWidget: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red),backgroundColor: Colors.grey[850],strokeWidth: 3,),
      ),
      message: message,
      messageTextStyle: TextStyle(
      ),
    );
    await pr.show();
    List<String> _listUrl=[];
    List<String> galleryIndexName =[];
    if(listImages != null) {
      for (int i = 0; i < listImages.length; i++) {
        String fileName = DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();
        StorageReference _listImages = FirebaseStorage().ref().child(
            'publicaciones').child(_docId).child(fileName);
        galleryIndexName.add(fileName);
        StorageUploadTask uploadTask = _listImages.putFile(
            (await listImages[i]));
        uploadTask.events.listen((event) {
        });
        StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
        _listUrl.add((await storageTaskSnapshot.ref.getDownloadURL()));
        if (_listUrl.length == imagesLength) {
          //TODO: crear documento
          await _publicacionesCollectionReference.document(_docId).setData(
              {
                "id": _docId,
                "publishedBy": userId,
                "publishedDate": publishedDate,
                "content": content,
                "heightSize": size,
                "gallery": _listUrl,
                "galleryIndexName": galleryIndexName
              }, merge: true).then((value) async{
            postNotification().sendNotificationOnBackground(
              title: 'Tenemos nuevo contenido',
              docId: _docId,
              uid: userId,
              isPost: true,
              hasUrl: false,
              body: 'Pulsa aqui para verlo.',
              url: null,
              image: _listUrl[0].toString()
            );
            await addComment(
                visible: false,
                uid: userId,
                message: '',
                id: _docId
            );
            pr.hide();
            Navigator.pop(context);
          });
        }
      }
    }else{
      //TODO: crear documento
      await _publicacionesCollectionReference.document(_docId).setData(
          {
            "id": _docId,
            "publishedBy": userId,
            "publishedDate": publishedDate,
            "content": content,
            "heightSize": size,
            "gallery": [],
            "galleryIndexName": []
          }, merge: true).then((value) async{
        postNotification().sendNotificationOnBackground(
            title: 'Tenemos nuevo contenido',
            docId: _docId,
            uid: userId,
            isPost: true,
            hasUrl: false,
            body: 'Pulsa aqui para verlo.',
            url: null,
            image: null
        );
        await addComment(
            visible: false,
            uid: userId,
            message: '',
            id: _docId
        );
        pr.hide();
        Navigator.pop(context);
      });
    }
  }
  //TODO: update document of type anuncio / publicaicon
  Future updatePublicacion({context, listImages, content, imagesLength, docId, galleryUrl, galleryImageName, nameLength}) async{
    String message =  'Actualizando';
    List<String> _listUrl = [];
    List<String> galleryIndexName = [];
    //TODO: progressbar
    var pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: false
    );
    pr.style(
      backgroundColor: Colors.white,
      borderRadius: 10,
      elevation: 10,
      progressWidget: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red),backgroundColor: Colors.grey[850],strokeWidth: 3,),
      ),
      message: message,
      messageTextStyle: TextStyle(
      ),
    );
    pr.show();
    if(listImages != null){
      for(int i =0; i<nameLength; i++){
        _listUrl.add(galleryUrl[i]);
        galleryIndexName.add(galleryImageName[i]);
      }
      for(int i =0; i <listImages.length; i++){
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        StorageReference _listImages = FirebaseStorage().ref().child('publicaciones').child(docId).child(fileName);
        galleryIndexName.add(fileName);
        StorageUploadTask uploadTask = _listImages.putFile((await listImages[i]));
        StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
        _listUrl.add((await storageTaskSnapshot.ref.getDownloadURL()));
        if(_listUrl.length == (imagesLength + nameLength)){
          //TODO: crear documento
          await _publicacionesCollectionReference.document(docId).setData(
              {
                "id": docId,
                "content": content,
                "heightSize": '0',
                "gallery": _listUrl,
                "galleryIndexName": galleryIndexName
              }, merge: true).then((value){
            pr.hide();
            Navigator.pop(context);
          });
        }
      }
    }else{
      Future.delayed(Duration(milliseconds: 600)).then((value) async{
        await _publicacionesCollectionReference.document(docId).setData(
            {
              "id": docId,
              "content": content,
              "heightSize": '0',
            }, merge: true).then((value){
          pr.hide();
          Navigator.pop(context);
        });
      });
    }
  }
  Future<bool> deleteAnuncioImage ({docId, indexImage, indexUrl}) async{
    StorageReference _galleryReference = FirebaseStorage().ref().child('publicaciones').child(docId);

    await _galleryReference.child(indexImage).delete().then((value){

      _publicacionesCollectionReference.document(docId).updateData({'galleryIndexName': FieldValue.arrayRemove([indexImage]), 'gallery':FieldValue.arrayRemove([indexUrl])}).then((value){
        return true;
      }).catchError((e){
        return false;
      });
      return true;

    });
  }
  //TODO: delete document of type anuncio / publicaicon
  Future deletePublicacion({docId, context, galleryPath, galleryCount}) async{
    final delete = Provider.of<DeleteAnuncioProvider>(context, listen: false);
    StorageReference _galleryReference = FirebaseStorage().ref().child('publicaciones').child(docId);
    if(galleryPath != null){
      for(int i=0; i<galleryCount; i++){
        _galleryReference.child(galleryPath[i]).delete();
        if((i+1) == galleryCount){
          await _publicacionesCollectionReference.document(docId).collection('comments').getDocuments().then((value) async{
            for(int i =0; i<value.documents.length; i++){
              _publicacionesCollectionReference.document(docId).collection('comments').document(value.documents[i].data['id']).delete();
              if((i+1) == value.documents.length){
                await _publicacionesCollectionReference.document(docId).collection('likeByUser').getDocuments().then((value) async{
                  if(value.documents.isEmpty){
                    await _publicacionesCollectionReference.document(docId).delete().then((value) async{
                      delete.isDeleted = true;
                      Navigator.pop(context);
                    });
                  }else{
                    for(int i=0; i<value.documents.length; i++){
                      _publicacionesCollectionReference.document(docId).collection('likeByUser').document(value.documents[i].data['id']).delete();
                      if((i+1) == value.documents.length){
                        await _publicacionesCollectionReference.document(docId).delete().then((value) async{
                          delete.isDeleted = true;
                          Navigator.pop(context);
                        });
                      }
                    }
                  }
                });
              }
            }
          });
        }
      }
    }else{
      await _publicacionesCollectionReference.document(docId).collection('comments').getDocuments().then((value) async{
        for(int i =0; i<value.documents.length; i++){
          _publicacionesCollectionReference.document(docId).collection('comments').document(value.documents[i].data['id']).delete();
          if((i+1) == value.documents.length){
            await _publicacionesCollectionReference.document(docId).collection('likeByUser').getDocuments().then((value) async{
              if(value.documents.isEmpty){
                await _publicacionesCollectionReference.document(docId).delete().then((value) async{
                  delete.isDeleted = true;
                  Navigator.pop(context);
                });
              }else{
                for(int i=0; i<value.documents.length; i++){
                  _publicacionesCollectionReference.document(docId).collection('likeByUser').document(value.documents[i].data['id']).delete();
                  if((i+1) == value.documents.length){
                    await _publicacionesCollectionReference.document(docId).delete().then((value) async{
                      delete.isDeleted = true;
                      Navigator.pop(context);
                    });
                  }
                }
              }
            });
          }
        }
      });
    }
  }
  //TODO: comments
  Stream<List<Comments>> viewComment({@required id}){
    return _publicacionesCollectionReference.document(id).collection('comments').orderBy('date',descending: false).snapshots()
        .map((update) => update.documents
        .map((snapshot) => snapshot.data != null ? Comments.fromMap(snapshot.data) : null).toList());
  }
  //TODO: add comment
  Future addComment({@required uid, @required id, @required message, @required visible}) async{
    var _docID = await _publicacionesCollectionReference.document(id).collection('comments').document().documentID;
    await _publicacionesCollectionReference.document(id).collection('comments').document(_docID).setData(
        {"id": _docID,"message" : message, "uid": uid, "date": DateTime.now().toString(), "visible": visible},merge: true
    );
  }
  //TODO: add comment
  Future updateComment({@required id, @required message, @required docId}) async{
    await _publicacionesCollectionReference.document(id).collection('comments').document(docId).setData(
        {"message": message,},merge: true);
  }
  //TODO: delete comment
  Future deleteComment({@required id, @required docId}) async{
    await _publicacionesCollectionReference
        .document(id)
        .collection('comments')
        .document(docId)
        .delete();
  }
  //TODO: list vistas (eliminar)
  Stream viewCount({@required id}){
    try{
      _publicacionesCollectionReference.document(id).collection('viewByUser').snapshots().listen((update){
        if(update.documents.isNotEmpty){
          var singleDocument = update.documents
              .map((snapshot) => ViewByUser.fromMap(snapshot.data))
              .where((mappedItem) => mappedItem.id != null)
              .toList();
          _viewCountStreamController.add(singleDocument);
        }
      });
      return _viewCountStreamController.stream;
    }catch(e){
      print(e);
      return null;
    }
  }
  //TODO: add like
  Future addLikeToCount({@required uid, @required id}) async{
    var _docID = await _publicacionesCollectionReference.document(id).collection('likeByUser').document().documentID;
    await _publicacionesCollectionReference.document(id).collection('likeByUser').document(_docID).setData(
        {"id": _docID, "uid": uid, "date": DateTime.now().toString()}
    );
  }
  //TODO: delete like
  Future deleteLikeCount({@required uid, @required id, @required docId}) async{
    await _publicacionesCollectionReference
        .document(id)
        .collection('likeByUser')
        .document(docId)
        .delete();
  }
  //TODO: list "me gusta"
  Stream<List<LikeByUser>> likeCount({@required id}){
    return _publicacionesCollectionReference.document(id).collection('likeByUser').snapshots()
        .map((update) => update.documents
        .map((snapshot) => snapshot.data != null ? LikeByUser.fromMap(snapshot.data) : null).toList());
  }
  //TODO: add view(eliminar)
  Future addViewToCount({@required uid, @required id}) async{
    var _docID = await _publicacionesCollectionReference.document(id).collection('viewByUser').document().documentID;
    if(uid != null && id != null){
      CollectionReference reference = _publicacionesCollectionReference.document(id).collection('viewByUser');
      StreamSubscription<QuerySnapshot> subscription = reference.snapshots().listen((update) async{
        if(update.documents.isNotEmpty){
          var singleDocument = update.documents
              .map((snapshot) => ViewByUser.fromMap(snapshot.data))
              .where((mappedItem) => mappedItem.id != null && mappedItem.uid ==uid)
              .toList();
          if(singleDocument.isEmpty){
            await _publicacionesCollectionReference.document(id).collection('viewByUser').document(_docID).setData(
                {"id": _docID, "uid": uid, "date": DateTime.now().toString()}).then((value){
            });
          }else{
          }
        }else{
          await _publicacionesCollectionReference.document(id).collection('viewByUser').document(_docID).setData(
              {"id": _docID, "uid": uid, "date": DateTime.now().toString()});
        }
      });
      subscription.resume();
      Future.delayed(Duration(milliseconds: 10)).then((value){
        subscription.cancel();
      });
    }else{
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //TODO: user
  //TODO: crear nuevo usuario
  Future createUser(User user) async {
    try {
      await _usersCollectionReference.where('email', isEqualTo: user.email).getDocuments().then((value) async{
        if(value.documents.isNotEmpty){
          await _usersCollectionReference.document(user.uid,).setData({"isOnline": true, "lastJoin": DateTime.now().toString()}, merge: true);

        }else{
          await _usersCollectionReference.document(user.uid).setData(user.toJson(), merge: true);
        }
      });

    } catch (e) {
      return e.message;
    }
  }
  //TODO: listar todo los usuarios
  Stream<List> listAllUsers(){
    return _usersCollectionReference.snapshots()
        .map((update) => update.documents
        .map((snapshot) => snapshot.data != null ? User.fromMap(snapshot.data) : null).toList());
  }
  //TODO: listar un unico usuario
  Stream listSingleDocument({@required documentId}){
    try{
      _usersCollectionReference.snapshots().listen((update){
        if(update.documents.isNotEmpty){
          var singleDocument = update.documents
              .map((snapshot) => User.fromMap(snapshot.data))
              .where((mappedItem) => mappedItem.uid != null && mappedItem.uid == documentId)
              .toList();
          _userStreamController.add(singleDocument);
        }
      });
      return _userStreamController.stream ?? null;
    }catch(e){
      print(e);
      return null;
    }
  }
  //TODO: update user status
  Future updateUserStatus({User user, isOnline, lastJoin}) async{
    try{
      await _usersCollectionReference.document(user.uid,).setData({"isOnline": isOnline, "lastJoin": lastJoin}, merge: true).then((snapshot){
      }).catchError((error){
        print(error.toString());
      });
    }catch(e){
      return e.toString();
    }
  }
  //TODO: update user fields
  Future updateUserdata({@required field, data, uid}) async{
    try{
      var searchIndex = await userSearchIndex(data);
      if(field == 'name'){
        await _usersCollectionReference.document(uid).updateData({"$field": data, "searchIndex": searchIndex},).then((value){
          return true;
        }).catchError((error){
          return false;
        });
        return true;
      }else if(field == 'birthDay'){
        if(data.toString().contains('/') || data != null){
          return false;
        }else{
          await _usersCollectionReference.document(uid).updateData({"$field": data},).then((value){
            return true;
          }).catchError((error){
            return false;
          });
          return true;
        }
      }else if(field == 'isAdmin'){
        bool _admin;
        if(data.toString() == 'true'){
          _admin = true;
        }else{
          _admin = false;
        }
        await _usersCollectionReference.document(uid).updateData({"$field": _admin},).then((value){
          return true;
        }).catchError((e){
          print(e.toString());
          return false;
        });
        return true;
      }else{
        await _usersCollectionReference.document(uid).updateData({"$field": data},).then((value){
          return true;
        }).catchError((e){
          print('e.toString()');
          return false;
        });
        return true;
      }
    }catch(e){
      print(e.toString());
      print('e.toString()');
      return false;
    }
  }
  //TODO: create list of name index
  userSearchIndex(String name){
    try{
      List<String> splitList = name.split(" ");
      List<String> indexList = [];

      for(int i = 0; i < splitList.length; i++){
        for(int j = 0; j < splitList[i].length; j++){
          indexList.add(splitList[i].substring(0, j+1).toLowerCase());
        }
      }
      return indexList;
    }catch(e){
      return 'error ==> ${e.toString()}';
    }
  }
  //TODO: search user
  Stream SearchUser({@required searchIndex, @required searchByMinisterio, @required isService, @required isAdmin}){
    try{
      if(searchByMinisterio != null && searchByMinisterio.toString().isNotEmpty){
        if(searchIndex != null && searchIndex != ''){
          _usersCollectionReference.where('ministerios', arrayContains: searchByMinisterio)
              .snapshots().listen((update){
            if(update.documents.isNotEmpty){
              var singleDocument = update.documents
                  .map((snapshot) => User.fromMap(snapshot.data))
                  .where((mappedItem) => mappedItem.uid != null  && mappedItem.ministerios != null && mappedItem.searchIndex.toString().contains(searchIndex) && (mappedItem.ministerios.toString().isEmpty || mappedItem.ministerios.toString() != '[]'))
                  .toList();
              _userStreamController.add(singleDocument);
            }
            else{
              return _userStreamController.add(null);
            }
          });
        }else{
          _usersCollectionReference.where('ministerios', arrayContains: searchByMinisterio)
              .snapshots().listen((update){
            if(update.documents.isNotEmpty){
              var singleDocument = update.documents
                  .map((snapshot) => User.fromMap(snapshot.data))
                  .where((mappedItem) => mappedItem.uid != null  && mappedItem.ministerios != null && (mappedItem.ministerios.toString().isEmpty || mappedItem.ministerios.toString() != '[]'))
                  .toList();
              _userStreamController.add(singleDocument);
            }
            else{
              return _userStreamController.add(null);
            }
          });
        }
      }else{
        if(searchIndex != null && searchIndex != ''){
          _usersCollectionReference.where('searchIndex', arrayContains: searchIndex)
              .snapshots().listen((update){
            if(update.documents.isNotEmpty){
              var singleDocument = update.documents
                  .map((snapshot) => User.fromMap(snapshot.data))
                  .where((mappedItem) => isService ? mappedItem.uid != null  && mappedItem.ministerios != null && (mappedItem.ministerios.toString().isEmpty || mappedItem.ministerios.toString() != '[]') : mappedItem.uid != null)
                  .toList();
              _userStreamController.add(singleDocument);
            }
            else{
              return _userStreamController.add(null);
            }
          });
        }else{
          _usersCollectionReference.snapshots().listen((update){
            if(update.documents.isNotEmpty){
              var singleDocument = update.documents
                  .map((snapshot) => User.fromMap(snapshot.data))
                  .where((mappedItem) => isAdmin ? mappedItem.isAdmin == true : isService ? mappedItem.uid != null  && mappedItem.ministerios != null && (mappedItem.ministerios.toString().isEmpty || mappedItem.ministerios.toString() != '[]') : mappedItem.uid != null)
                  .toList();
              _userStreamController.add(singleDocument);
            }else{
              return null;
            }
          });
        }
      }
      return _userStreamController.stream;
    }catch(e){
      print(e);
      return null;
    }
  }
  //TODO: update user ministerio
  Future updateUserMinisterio({@required ministerio, uid}) async{
    try{
      var doc = await _usersCollectionReference.document(uid).get();
      List array = doc.data['ministerios'];
      if(array.contains('')){
        await _usersCollectionReference.document(uid).updateData({'ministerios': ['']}).then((value){
          return true;
        }).catchError((e){
          return false;
        });
      }else{
        if(array.contains(ministerio) == true){
          await _usersCollectionReference.document(uid).updateData({'ministerios': FieldValue.arrayRemove([ministerio])}).then((value){
            return true;
          }).catchError((e){
            return false;
          });
        }else{
          await _usersCollectionReference.document(uid).updateData({'ministerios': FieldValue.arrayUnion([ministerio])}).then((value){
            return true;
          }).catchError((e){
            return false;
          });
        }
      }
    }catch(e){
      return false;
    }
  }
  //TODO: notifications
  Stream<List<NotificationModel>> notificationListener({uid}){
    return _usersCollectionReference.document(uid).collection('notifications')
    .orderBy("date", descending: true)
        .snapshots()
        .map((update) => update.documents
        .map((snapshot) => snapshot.data != null ?  NotificationModel.fromMap(snapshot.data): null)
        .toList());
  }
  Future<bool> createNotification({message,context}) async{
    final user = Provider.of<User>(context, listen: false);
    CollectionReference _db = Firestore.instance.collection('users').document().collection('notifications');
    var _docId = _db.document().documentID;
    NotificationModel _notificationModel = NotificationModel(
      uid: message['content']['data']['uid'],
      image: message['content']['data']['image'],
      id: _docId,
      docId:  message['content']['data']['docId'],
      title:  message['content']['data']['title'],
      url:  message['content']['data']['url'],
      date: DateTime.now().toString(),
      body:  message['content']['data']['body'],
      hasUrl:  message['content']['data']['hasUrl'].toString() == 'true' ? true : false,
      isPost:  message['content']['data']['isPost'].toString() == 'true' ? true : false,
      view: false,
    );
    return await _usersCollectionReference.document(user.uid).collection('notifications')
        .document(_notificationModel.id)
        .setData(_notificationModel.toJson()).then((value) => true)
        .catchError((e) => false);
  }
  Future<bool> updateNotificationState({docId, uid}) async{
    return await _usersCollectionReference.document(uid).collection('notifications')
        .document(docId)
        .updateData({"view": true}).then((value) => true)
        .catchError((e) => false);
  }
  Future<bool> deleteNotification({docId, uid}) async{
    return await _usersCollectionReference.document(uid).collection('notifications')
        .document(docId)
        .delete().then((value) => true)
        .catchError((e) => false);
  }
/////////////////////////////////////////////////////////////////////////////////////
  //TODO: seccion de youtube
  //TODO: create youtube video document
  Future createYoutubeDocument(Video video) async{
    try{
      await _predicationCollectionReference.document(video.id).setData(video.toJson());
    }catch(e){
      return e.message;
    }
  }
  //TODO: create youtube channel document
  Future createChannel(Channel channel)async{
    try{
      await _channelCollectionReference.document(channel.id).setData(channel.toJson());
    }catch(e){
      return e.message;
    }
  }
  //TODO: fetch channel data
  Stream channelRealTimeData(){
    _channelCollectionReference.snapshots().listen((channelSnapshot) {
      if(channelSnapshot.documents.isNotEmpty){
        var channel = channelSnapshot.documents
            .map((snapshot) => Channel.fromData(snapshot.data))
            .where((mapItem) => mapItem.id != null)
            .toList();
        _channelDataStreamController.add(channel);
      }
    });
    return _channelDataStreamController.stream;
  }
  //TODO: actualizar datos del canal de youtube
  Future updateChannelData(Channel channel)async{
    try {
      await _channelCollectionReference.document(channel.id).updateData(channel.toJson());
      return true;
    } catch (e) {
      if(e is PlatformException){
        return e.message;
      }
      return e.toString();
    }
  }
  //TODO: list videos
  Stream<List<Video>> videoRealTimeData(){
    return _predicationCollectionReference.orderBy('date',descending: true).snapshots()
        .map((update) => update.documents
        .map((snapshot) => snapshot.data != null ? Video.fromData(snapshot.data) : null).toList());
  }
//////////////////////////////////////////////////////////////////////////////////////////////
//TODO: seccion de ministerio
  //TODO: crear ministerio
  Future<bool> createMinisterio(Ministerio ministerio) async{
      return await _ministerioCollectionReference.document(ministerio.id).setData(ministerio.toJson())
          .then((value) => true)
          .catchError((e) => false);
  }
  //TODO: ministerio
  Stream<List<Ministerio>> ministerioRealTimerData(){
    return _ministerioCollectionReference.snapshots()
        .map((update) => update.documents
        .map((snapshot) => snapshot.data != null ? Ministerio.fromData(snapshot.data) : null).toList());
  }
  //TODO: actualziar informacion de ministerio
  Future<bool> updateMinisterio(Ministerio ministerio) async{
    return await _ministerioCollectionReference.document(ministerio.id).updateData(ministerio.toJson())
        .then((value) => true)
        .catchError((e) => false);
  }
  //TODO: eliminar ministerio
  Future deleteMinisterio(id) async{
    return await _ministerioCollectionReference.document(id).delete().then((value) => true).catchError((e) => false);
  }
  Future<bool> deleteUserLeader({docId, uid}) async{
    return await _ministerioCollectionReference.document(docId).updateData({'leaderList' : FieldValue.arrayRemove([uid])}).then((value) => true).catchError((e) => false);
  }
//////////////////////////////////////////////////////////////////////////////////////////////
//TODO: seccion de banner servidor
//TODO: update banner
  Future<bool> updateServidorBanner({link}) async{
    return await _bannerCollectionReference.document('mWm7w5RO3XCfCFArqzIE').updateData({"imageUrl": link})
        .then((value) => true)
        .catchError((e) => false);
  }
  Stream banner(){
    return _bannerCollectionReference.snapshots()
        .map((update) => update.documents
        .map((snapshot) => snapshot.data != null ?  BannerModel.fromData(snapshot.data): null).toList());

  }
}