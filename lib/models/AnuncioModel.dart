
class Publicaciones{
  final String id;
  final String imageUrl;
  final String publishedBy;
  final String publishedDate;
  final String content;
  final String heightSize;
  final gallery;
  final type;
  final eventDate;
  final galleryIndexName;

  Publicaciones({
    this.id,
    this.imageUrl,
    this.publishedBy,
    this.publishedDate,
    this.content,
    this.heightSize,
    this.type,
    this.eventDate,
    this.gallery, this.galleryIndexName
  });

  Publicaciones.fromData(Map<String, dynamic> data)
  : id = data['id'],
    imageUrl = data['imageUrl'],
    publishedBy = data['publishedBy'],
    publishedDate = data['publishedDate'],
    heightSize = data['heightSize'],
    type = data['type'],
    eventDate = data['eventDate'],
    gallery = data['gallery'],
    galleryIndexName = data['galleryIndexName'],
    content = data['content'];

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'imageUrl': imageUrl,
      'publishedBy': publishedBy,
      'publishedDate': publishedDate,
      'content': content,
      'type': type,
      'eventDate': eventDate,
      'gallery': gallery,
      'galleryIndexName': galleryIndexName,
      'heightSize': heightSize
    };
  }

  static Publicaciones fromMap(Map<String, dynamic> map){
    if(map != null){
      return Publicaciones(
          id: map['id'],
          imageUrl: map['imageUrl'],
          publishedBy: map['publishedBy'],
          publishedDate: map['publishedDate'],
          content: map['content'],
          heightSize: map['heightSize'],
          type: map['type'],
          galleryIndexName: map['galleryIndexName'],
          eventDate:map['eventDate'],
          gallery: map['gallery']
      );
    }else{
      return null;
    }
  }
}

class LikeByUser{
  final String id;
  final String uid;
  final String date;

  LikeByUser({
    this.id,
    this.uid,
    this.date
  });

  LikeByUser.fromData(Map<String, dynamic> data)
  : id = data['id'],
    uid = data['uid'],
    date = data['date'];

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'uid': uid,
      'date': date
    };
  }

  static LikeByUser fromMap(Map<String, dynamic> map){
    if(map != null){
      return LikeByUser(
        id: map['id'],
        uid: map['uid'],
        date: map['date']
      );
    }else{
      return null;
    }
  }
}

class ViewByUser{
  final String id;
  final String uid;
  final String date;

  ViewByUser({
    this.id,
    this.uid,
    this.date
  });

  ViewByUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        uid = data['uid'],
        date = data['date'];

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'uid': uid,
      'date': date
    };
  }

  static ViewByUser fromMap(Map<String, dynamic> map){
    if(map != null){
      return ViewByUser(
          id: map['id'],
          uid: map['uid'],
          date: map['date']
      );
    }else{
      return null;
    }
  }
}

class Comments{
  final String id;
  final String uid;
  final String date;
  final message;
  final visible;

  Comments({
    this.id,
    this.uid,
    this.date,
    this.message,
    this.visible
  });

  Comments.fromData(Map<String, dynamic> data)
      : id = data['id'],
        uid = data['uid'],
        message = data['message'],
        visible = data['visible'],
        date = data['date'];

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'uid': uid,
      'date': date,
      'visivle': visible,
      'message': message
    };
  }

  static Comments fromMap(Map<String, dynamic> map){
    if(map != null){
      return Comments(
          id: map['id'],
          uid: map['uid'],
          message: map['message'],
          date: map['date'],
          visible: map['visible']
      );
    }else{
      return null;
    }
  }
}