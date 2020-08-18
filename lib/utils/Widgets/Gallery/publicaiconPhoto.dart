import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class HeroPhotoViewWrapper extends StatelessWidget {
  const HeroPhotoViewWrapper({
    this.imageProvider,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.docId
  });

  final ImageProvider imageProvider;
  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final docId;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: PhotoView(
              imageProvider: imageProvider,
              loadingBuilder: loadingBuilder,
              backgroundDecoration: backgroundDecoration,
              minScale: 0.1,
              maxScale: 1.0,
              filterQuality: FilterQuality.high,
              heroAttributes:  PhotoViewHeroAttributes(tag: docId),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              height: 90,
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close, color: Colors.white,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}