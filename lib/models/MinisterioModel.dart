class Ministerio{
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final String creationDate;
  final List leaderList;

  Ministerio({
    this.name,
    this.id,
    this.imageUrl,
    this.description,
    this.creationDate,
    this.leaderList
  });

  Ministerio.fromData(Map<String, dynamic> data)
    : id = data['id'],
      name = data['name'],
      description = data['description'],
      leaderList = data['leaderList'],
      creationDate = data['creationDate'],
      imageUrl = data['imageUrl'];

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'creationDate': creationDate,
      'leaderList': leaderList
    };
  }

  static Ministerio fromMap(Map<String, dynamic> map){
    if(map != null){
      return Ministerio(
        id: map['id'],
        name: map['name'],
        imageUrl: map['imageUrl'],
        description: map['description'],
        creationDate: map['leaderList'],
        leaderList: map['leaderList']
      );
    }else{
      return null;
    }
  }

}