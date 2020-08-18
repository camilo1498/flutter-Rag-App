import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/models/videoModel.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';
import 'package:ragapp/utils/keys.dart';
import 'package:url_launcher/url_launcher.dart';

class PredicationScreen extends StatefulWidget {
  @override
  _PredicationScreenState createState() => _PredicationScreenState();
}

class _PredicationScreenState extends State<PredicationScreen> {

  //TODO: objetos

  //TODO: instancias
  FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('hi predication screen!');
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('bye predication screen!');

  }

  //TODO: OPEN LINKS ON ANOTHER APP
  _launchURL(url) async {
    print('launch url!');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  //TODO: widgets
  _buildVideo(video) {
    return GestureDetector(
      onTap: (){
        FlutterYoutube.playYoutubeVideoById(
          apiKey: Platform.isIOS ? IOS_API_KEY : ANDROID_API_KEY,
          videoId: "${video.id}",
          fullScreen: true,
          autoPlay: true,
        );
      },
      //hero
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.only(right:0,left: 0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.transparent,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 90,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[500],
                    offset: Offset(0, 1.5),
                    spreadRadius: 0.1,
                    blurRadius: 0.1
                  )
                ]
              ),
              child: CachedNetworkImage(
                color: Colors.grey[850],
                imageUrl: video.thumbnailUrl,
                filterQuality: FilterQuality.high,
                placeholder: (context, url){
                  return Center(child: CircularProgressIndicator(backgroundColor: Colors.white,valueColor: AlwaysStoppedAnimation(Colors.red),strokeWidth: 2,));
                },
                imageBuilder: (context, url){
                  return Container(
                    height: 90,
                    width: 160,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: url,
                            fit: BoxFit.cover
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8,bottom: 4),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.all(Radius.circular(2))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4,right: 4, top: 2, bottom: 2),
                            child: Text(
                              _getDuration(video.duration),
                              style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      video.title,
                      style: TextStyle(
                          color: Colors.grey[750],
                          fontSize: 12.0,
                          fontFamily: 'Glenn Slab',
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Material(
                    color: Colors.transparent,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          color: Colors.grey[530],
                          size: 12,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          '${formatDate(DateTime.parse(video.date), ['d',' ','M',' ','yyyy'])}',
                          style: TextStyle(
                              color: Colors.grey[530],
                              fontSize: 12.0,
                              fontFamily: 'Glenn Slab',
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    ///////////////////////////////////////////////////////////////
    Widgets _widgets = Widgets();
    ///////////////////////////////////////////////////////////////
    var screenHDP = ScreenUtil.screenHeightDp;
    final video = Provider.of<List<Video>>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
          color: Colors.grey[350],
          child: NestedScrollView(
            headerSliverBuilder: (context, value){
              return<Widget>[
                SliverAppBar(
                  expandedHeight: 170,
                  backgroundColor: Colors.black,
                  bottom: PreferredSize(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15,bottom: 2),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: Tooltip(
                              message: 'Abrir en Yotube',
                              child: InkWell(
                                onTap: (){
                                  _launchURL('https://www.youtube.com/channel/UCFN5orUg3KhJcH23dCG2d0g');
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Pulse(
                                      infinite: true,
                                      child: Icon(
                                        Icons.arrow_downward,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'You',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(Radius.circular(5))
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 2,left: 2),
                                            child: Text(
                                              'Tube',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                  fontSize: 15
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ),
                      ),
                      preferredSize: Size.fromHeight(170.0)),
                  pinned: true,
                  floating: true,
                  snap: true,
                  stretch: true,
                  elevation: 10,
                  flexibleSpace: StreamBuilder(
                    stream: _firestoreService.channelRealTimeData(),
                    builder: (context, snapshot){
                      if(snapshot.data != null){
                        return Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                              color: Colors.grey[850],
                              imageUrl: snapshot.data[0].channerBanner,
                              filterQuality: FilterQuality.high,
                              placeholder: (context, url){
                                return Center(child: CircularProgressIndicator(backgroundColor: Colors.white,valueColor: AlwaysStoppedAnimation(Colors.red),strokeWidth: 2,));
                              },
                              imageBuilder: (context, url){
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[850],
                                    image: DecorationImage(
                                        image: url,
                                        fit: BoxFit.cover
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black26,
                                              Colors.black12,
                                              Colors.black
                                            ]
                                        )
                                    ),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, bottom: 0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  height: 80,
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.grey[850],
                                        radius: 30,
                                        child: CachedNetworkImage(
                                          color: Colors.grey[850],
                                          imageUrl: snapshot.data[0].profilePictureUrl,
                                          filterQuality: FilterQuality.high,
                                          placeholder: (context, url){
                                            return CircularProgressIndicator(backgroundColor: Colors.white,valueColor: AlwaysStoppedAnimation(Colors.red),strokeWidth: 2,);
                                          },
                                          imageBuilder: (context, url){
                                            return Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius: BorderRadius.all(Radius.circular(90)),
                                                  image: DecorationImage(
                                                    image: url,
                                                  )
                                              ),
                                            );
                                          },
                                        )
                                      ),
                                      SizedBox(width: 15,),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data[0].title,
                                              style: TextStyle(
                                                  color: Colors.grey[200],
                                                  fontSize: 22,
                                                  fontFamily: 'Glenn Slab',
                                                  fontWeight: FontWeight.w600
                                              ),
                                            ),
                                            SizedBox(height: 0,),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.group,
                                                  size: 13,
                                                  color: Colors.grey[400],
                                                ),
                                                SizedBox(width: 5,),
                                                Text(
                                                  '${snapshot.data[0].subscriberCount} Subscribers',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontFamily: 'Glenn Slab',
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.grey[400]
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.ondemand_video,
                                                  size: 13,
                                                  color: Colors.grey[400],
                                                ),
                                                SizedBox(width: 5,),
                                                Text(
                                                  '${snapshot.data[0].videoCount} videos',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontFamily: 'Glenn Slab',
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.grey[400]
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }else{
                        return _widgets.showCircularProgressIndicator(
                            context: context,
                            color: Colors.grey[850],
                            text: 'Cargando Información'
                        );
                      }
                    },
                  ),
                ),
              ];
            },
            body: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SafeArea(
                bottom: false,
                top: false,
                child: video != null ? CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index){
                        return _buildVideo(video[index]);
                      },
                        childCount: video.length,
                      ),
                    )
                  ],
                ): _widgets.showCircularProgressIndicator(
                    context: context,
                    color: Colors.grey[300],
                    text: 'Cargando Información'
                ),
              ) ,
            ),
          )
      ),
    );
  }

  String _getDuration(String duration) {
    if (duration.isEmpty) return null;
    duration = duration.replaceFirst("PT", "");

    var validDuration = ["H", "M", "S"];
    if (!duration.contains(new RegExp(r'[HMS]'))) {
      return null;
    }
    var hour = 0, min = 0, sec = 0;
    for (int i = 0; i < validDuration.length; i++) {
      var index = duration.indexOf(validDuration[i]);
      if (index != -1) {
        var valInString = duration.substring(0, index);
        var val = int.parse(valInString);
        if (i == 0)
          hour = val;
        else if (i == 1)
          min = val;
        else if (i == 2) sec = val;
        duration = duration.substring(valInString.length + 1);
      }
    }
    List buff = [];
    if (hour != 0) {
      buff.add(hour.toString());
    }
    if (min < 10) {
      if (hour != 0)
        buff.add(min.toString().padLeft(2, '0'));
      else
        buff.add(min.toString());
    } else {
      buff.add(min.toString().padLeft(2, '0'));
    }
    buff.add(sec.toString().padLeft(2, '0'));

    return buff.join(":");
  }
}