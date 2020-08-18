import 'package:flutter/cupertino.dart';

//TODO: anuncios
class Content{
  final id;
  final imageUrl;

  Content({@required this.imageUrl, this.id});

  Content.fromData(Map<String, dynamic> data)
    : id = data['id'],
      imageUrl = data['imageUrl'];

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'imageUrl': imageUrl,
    };
  }

  static Content fromMap(Map<String, dynamic> map){
    if(map != null){
      return Content(
        id: map['id'],
        imageUrl: map['imageUrl']
      );
    }else{
      return null;
    }
  }

}