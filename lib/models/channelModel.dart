import 'package:ragapp/models/videoModel.dart';

class Channel {

  final String id;
  final String title;
  final String profilePictureUrl;
  final String subscriberCount;
  final String videoCount;
  final String uploadPlaylistId;
  final String channerBanner;
  List<Video> videos;

  Channel({
    this.id,
    this.title,
    this.profilePictureUrl,
    this.subscriberCount,
    this.videoCount,
    this.uploadPlaylistId,
    this.channerBanner,
    this.videos,
  });

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'],
      title: map['snippet']['title'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      subscriberCount: map['statistics']['subscriberCount'],
      videoCount: map['statistics']['videoCount'],
      channerBanner: map['brandingSettings']['image']['bannerTvHighImageUrl'],
      uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'],
    );
  }

  Channel.fromData(Map<String, dynamic> data)
  : id = data['id'],
    title = data['title'],
    profilePictureUrl = data['profilePictureUrl'],
    subscriberCount = data['subscriberCount'],
    videoCount = data['videoCount'],
    channerBanner = data['channerBanner'],
    uploadPlaylistId = data['uploadPlaylistId']
  ;

  Map<String, dynamic>toJson(){
    return{
      'id': id,
      'title' : title,
      'profilePictureUrl' : profilePictureUrl,
      'subscriberCount': subscriberCount,
      'videoCount' : videoCount,
      'channerBanner': channerBanner,
      'uploadPlaylistId': uploadPlaylistId,
    };
  }

}
//https://www.googleapis.com/youtube/v3/videos?id=mR7OhzLZe4U&key=AIzaSyDmLt4O-VNtSMA_Be1dMpkZ5C5AJTm3d4A&part=snippet,contentDetails,statistics,status
