import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    this.create,
    @required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final galleryItems;
  final Axis scrollDirection;
  final create;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  //TODO: variables
  int currentIndex;
  var path;
  String _message = "";
  String _path = "";
  String _size = "";
  String _mimeType = "";
  File _imageFile;
  int _progress = 0;
  //TODO: global keys
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    currentIndex = widget.initialIndex;
    path = widget.galleryItems;
    ImageDownloader.callback(onProgressUpdate: (String imageId, int progress) {
      setState(() {
        _progress = progress;
      });
    });
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldGlobalKey,
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (context, index){
                return _buildItem(context, index, path);
              },
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Imagen ${currentIndex + 1 } de ${path.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: 90,
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  actions: <Widget>[

                    Visibility(
                      visible: !widget.create,
                      child: InkWell(
                        onTap: (){
                          Clipboard.setData(
                            ClipboardData(text: path[currentIndex].toString())
                          );
                          Widgets().snackBar(
                            scaffoldGlobalKey: scaffoldGlobalKey,
                            textColor: Colors.black.withOpacity(0.8),
                            color: Colors.white.withOpacity(0.8),
                            message: 'Enlace copiado.'
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.link, color: Colors.white,),
                        ),
                      ),
                    ),
                    SizedBox(width: 8,),
                    Visibility(
                      visible: !widget.create,
                      child: InkWell(
                        onTap: () async{
                          await _downloadImage(path[currentIndex]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.file_download, color: Colors.white,),
                        ),
                      ),
                    ),
                    SizedBox(width: 15,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(context, index, path) {
    return PhotoViewGalleryPageOptions.customChild(
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: widget.create ? FileImage(path[index]) : NetworkImage(path[index])
            )
        ),
      ),
      childSize: const Size(300, 300),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
      heroAttributes: PhotoViewHeroAttributes(tag: path[index]),
    );
  }

  Future<void> _downloadImage(String url, {AndroidDestinationType destination, bool whenError = false, String outputMimeType}) async {
    String fileName;
    String path;
    int size;
    String mimeType;
    try {
      String imageId;

      if (whenError) {
        imageId = await ImageDownloader.downloadImage(url, outputMimeType: outputMimeType).catchError((error) {
          if (error is PlatformException) {
            var path = "";
            if (error.code == "404") {
              print("Not Found Error.");
            } else if (error.code == "unsupported_file") {
              print("UnSupported FIle Error.");
              path = error.details["unsupported_file_path"];
            }
            setState(() {
              _message = error.toString();
              _path = path;
            });
          }

          print(error);
        }).timeout(Duration(seconds: 10), onTimeout: () {
          print("timeout");
          return;
        });
      } else {
        if (destination == null) {
          imageId = await ImageDownloader.downloadImage(
            url,
            outputMimeType: outputMimeType,
          );
        } else {
          imageId = await ImageDownloader.downloadImage(
            url,
            destination: destination,
            outputMimeType: outputMimeType,
          );
        }
      }

      if (imageId == null) {
        return;
      }
      fileName = await ImageDownloader.findName(imageId);
      path = await ImageDownloader.findPath(imageId);
      size = await ImageDownloader.findByteSize(imageId);
      mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      setState(() {
        _message = error.message;
        Widgets().snackBar(
            scaffoldGlobalKey: scaffoldGlobalKey,
            textColor: Colors.black.withOpacity(0.8),
            color: Colors.white.withOpacity(0.8),
            message: 'Error al descargar.'
        );
      });
      return;
    }

    if (!mounted) return;

    setState(() {
      var location = Platform.isAndroid ? "Directory" : "Photo Library";
      _message = 'Saved as "$fileName" in $location.\n';
      _size = 'size:     $size';
      _mimeType = 'mimeType: $mimeType';
      _path = path;
      Widgets().snackBar(
          scaffoldGlobalKey: scaffoldGlobalKey,
          textColor: Colors.black.withOpacity(0.8),
          color: Colors.white.withOpacity(0.8),
          message: 'Imagen guardada correctamente.'
      );
      return;
    });
  }
}