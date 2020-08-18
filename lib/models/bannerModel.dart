class BannerModel {
  final String id;
  final String imageUrl;

  BannerModel({
    this.id,
    this.imageUrl,
  });

  factory BannerModel.fromMap(Map<String, dynamic> data) {
    return BannerModel(
        id: data['id'],
      imageUrl: data['imageUrl'],
    );
  }

  BannerModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        imageUrl = data['imageUrl']
  ;

  Map<String, dynamic>toJson(){
    return{
      'id': id,
      'imageUrl' : imageUrl,
    };
  }

}