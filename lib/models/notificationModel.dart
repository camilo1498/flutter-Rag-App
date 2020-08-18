
class NotificationModel{
 final id;
 final view;
 final title;
 final body;
 final image;
 final docId;
 final url;
 final hasUrl;
 final uid;
 final isPost;
 final date;

 NotificationModel({
    this.uid,
    this.id,
    this.docId,
    this.title,
    this.image,
    this.url,
    this.body,
    this.hasUrl,
    this.isPost,
    this.view,
    this.date
  });

 NotificationModel.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        view = data['view'],
        isPost = data['isPost'],
        hasUrl = data['hasUrl'],
        body = data['body'],
        title = data['title'],
        url = data['url'],
        docId = data['docId'],
        image = data['image'],
        date = data['date'],
        id = data['id'];

  Map<String, dynamic> toJson(){
    return {
      'uid': uid,
      'view': view,
      'isPost': isPost,
      'hasUrl': hasUrl,
      'body': body,
      'title': title,
      'url': url,
      'docId': docId,
      'date': date,
      'image': image,
      'id': id
    };
  }
  static NotificationModel fromMap(Map<String, dynamic> map){
    if(map != null){
      return NotificationModel(
          uid: map['uid'],
          view: map['view'],
          isPost: map['isPost'],
          hasUrl: map['hasUrl'],
          body: map['body'],
          title: map['title'],
          url: map['url'],
          docId: map['docId'],
          image: map['image'],
          date: map['date'],
          id: map['id']
      );
    }else{
      return null;
    }
  }
}