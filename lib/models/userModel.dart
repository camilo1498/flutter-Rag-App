import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String uid;
  final String name;
  final String phone;
  final String email;
  final bool isOnline;
  final String birthDay;
  final String status;
  final String photoUrl;
  final String firstJoin;
  final String lastJoin;
  final ministerios;
  final String address;
  final String deviceToken;
  final bool isAdmin;
  final searchIndex;

  User({
    this.uid,
    this.phone,
    this.email,
    this.name,
    this.isOnline,
    this.status,
    this.deviceToken,
    this.address,
    this.birthDay,
    this.firstJoin,
    this.lastJoin,
    this.ministerios,
    this.photoUrl,
    this.isAdmin,
    this.searchIndex
  });

  User.fromData(Map<String, dynamic> data)
    : uid = data['uid'],
      email = data['email'],
      isOnline = data['isOnline'],
      name = data['name'],
      photoUrl = data['photoUrl'],
      ministerios = data['ministerios'],
      lastJoin = data['lastJoin'],
      firstJoin = data['firstJoin'],
      birthDay = data['birthDay'],
      address = data['address'],
      deviceToken = data['deviceToken'],
      status = data['status'],
      phone = data['phone'],
      isAdmin = data['isAdmin'],
      searchIndex = data['searchIndex'];

  Map<String, dynamic> toJson(){
    return {
      'uid': uid,
      'email': email,
      'isOnline': isOnline,
      'name': name,
      'photoUrl': photoUrl,
      'ministerios': ministerios,
      'lastJoin': lastJoin,
      'firstJoin': firstJoin,
      'birthDay': birthDay,
      'address': address,
      'deviceToken': deviceToken,
      'status': status,
      'phone': phone,
      'isAdmin': isAdmin,
      'searchIndex': searchIndex
    };
  }
  static User fromMap(Map<String, dynamic> map){
    if(map != null){
      return User(
          uid: map['uid'],
          email: map['email'],
          isOnline: map['isOnline'],
          name: map['name'],
          photoUrl: map['photoUrl'],
          ministerios: map['ministerios'],
          lastJoin: map['lastJoin'],
          firstJoin: map['firstJoin'],
          birthDay: map['birthDay'],
          address: map['address'],
          deviceToken: map['deviceToken'],
          status: map['status'],
          phone: map['phone'],
          isAdmin: map['isAdmin'],
          searchIndex: map['searchIndex']
      );
    }else{
      return null;
    }
  }
}