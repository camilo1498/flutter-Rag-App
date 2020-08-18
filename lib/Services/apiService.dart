import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/models/channelModel.dart';
import 'package:ragapp/models/videoModel.dart';
import 'package:ragapp/utils/keys.dart';

class APIService{

  APIService._instantiate();

  static final APIService instance = APIService._instantiate();
  //TODO:objeto
  FirestoreService _service = FirestoreService();

  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';
  var API_KEY = '';
  Future<Channel> fecthChannel({String channelId}) async{
    if(Platform.isIOS){
      API_KEY = IOS_API_KEY;
      print('ios=> $API_KEY ==== $IOS_API_KEY');
    }else{
      API_KEY =ANDROID_API_KEY;
      print('Android=> $API_KEY ==== $ANDROID_API_KEY');
    }

    Map<String, String> parameters ={
      'part': 'snippet, contentDetails, statistics, brandingSettings',
      'id': channelId,
      'key': API_KEY
    };
    Uri uri = Uri.https(
        _baseUrl,
        '/youtube/v3/channels',
        parameters
    );
    print(uri);
    Map<String, String> headers ={
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    //TODO: get channel
    var response = await http.get(uri, headers: headers);
    if(response.statusCode == 200){
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);
      _service.updateChannelData(Channel.fromMap(data));

      //TODO: fetch first back of videos from uploads playlist
      channel.videos = await fetchVideosFromPlayList(
          playlistId: channel.uploadPlaylistId
      );
      return channel;
    }else{
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlayList({String playlistId}) async{
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '15',
      'pageToken': _nextPageToken,
      'key': API_KEY
    };
    //TODO: get IDVideos
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    print(uri);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    //TODO:get playlist videos
    var response = await http.get(uri,headers: headers);
    if(response.statusCode == 200){
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      //TODO: fetch first fiveTeen videos from uploads playlist
      List<Video> videos = [];
      List<String> videoId= [];
      //TODO: este si
      List<Video> videosUri = [];
      /////////////////////////////////////
      //////////////////////////
      //TODO: add videoId to array
      videosJson.forEach((json) {
        videoId.add(
          json['snippet']['resourceId']['videoId'],
        );
      });
      Map<String, String> idParameters ={
        'part': 'snippet, contentDetails, statistics, status',
        'id': videoId.toString(),
        'key': API_KEY
      };
      //TODO: new uri
      Uri uri2 = Uri.https(
          _baseUrl,
          '/youtube/v3/videos',
          idParameters
      );
      var idResponse = await http.get(uri2, headers: headers);
      if(idResponse.statusCode == 200){
        var data = jsonDecode(idResponse.body);
        List<dynamic> videos = data['items'];
        videos.forEach((json) {
          _service.createYoutubeDocument(Video.fromMap(json));
          videosUri.add(
            Video.fromMap(json),
          );
        });
      }
      print(uri2);
      return videosUri;
    }else{
      throw json.decode(response.body)['error']['message'];
    }
  }

}