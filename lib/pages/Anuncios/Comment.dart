import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/models/AnuncioModel.dart';
import 'package:ragapp/models/userModel.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentPage extends StatefulWidget {
  var index;
  var docId;
  var usersId;
  var indexName;
  var likeCount;
  CommentPage({this.indexName, this.index, this.usersId, this.docId, this.likeCount});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  //TODO: global keys
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  //TODO: controllers
  FocusNode _textNode = FocusNode();
  TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  //TODO: variables
  bool _isEditingContent = false;
  var _editingIndex;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List>(context);
    final user = Provider.of<List<User>>(context, listen: false);
    return  Scaffold(
      key: scaffoldGlobalKey,
      backgroundColor: Colors.transparent,
      body: StreamProvider<List<Comments>>.value(
        value: FirestoreService().viewComment(id: widget.docId),
        child: Builder(
          builder: (context){
            var stream = Provider.of<List<Comments>>(context);
            return Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: stream != null &&  stream.length != 0? Padding(
                        padding: const EdgeInsets.only(top: 90, bottom: 50,right: 12, left: 12),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: stream.length,
                          itemBuilder: (context, index){
                            var indexName =  widget.usersId.indexOf(stream[index].uid);
                            if(stream != null && stream.length != 0){
                              Future.delayed(Duration(milliseconds: 500)).then((value){
                                if(_scrollController.positions.isNotEmpty && !_isEditingContent){
                                  _scrollController.animateTo(_scrollController.position.maxScrollExtent,duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                                }
                              });
                            }
                            return Visibility(
                              visible: stream[index].visible,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    _userAvatar(indexName: indexName,users:  users, localUser: false),
                                    SizedBox(width: 10,),
                                    Container(
                                      padding: EdgeInsets.only(top: 10,bottom: 10,left: 10, right: 1),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15)
                                          ),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0.1, 0.1),
                                              color: Colors.grey[400],
                                              spreadRadius: 0.5,
                                              blurRadius: 3
                                          )
                                        ]
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${users[indexName].name}',
                                                style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 14
                                                ),
                                              ),
                                              SizedBox(height: 3,),
                                              Container(
                                                constraints: BoxConstraints(
                                                  maxWidth: MediaQuery.of(context).size.width/1.6,
                                                ),
                                                child: Text(
                                                  '${stream[index].message}',

                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.grey[900],
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 1,),
                                              Text(
                                                '${timeago.format(DateTime.parse(stream[index].date,),locale: 'en_short')}',
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 10,),
                                          Visibility(
                                            visible: user[0].uid == stream[index].uid || user[0].isAdmin,
                                            child: InkWell(
                                              onTap: (){
                                                adminSheet(
                                                  uid: stream[index].uid,
                                                  context: context,
                                                  content: stream[index].message,
                                                  docId: stream[index].id,
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(left: 2,right: 2),
                                                child: Icon(Icons.more_vert, color: Colors.grey[900],size: 20,),
                                              )
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                    )
                        : Container(
                        height: MediaQuery.of(context).size.height/1.5,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.error_outline,
                                color: Colors.black38.withOpacity(0.2),
                                //Colors.grey[400],
                                size: 100,),
                              SizedBox(height: 5,),
                              Text(
                                'No hay comentarios',
                                style: TextStyle(
                                    color:Colors.black38.withOpacity(0.2),
                                    //Colors.grey[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0.1, -0.1),
                            color: Colors.grey[400],
                            spreadRadius: 0.5,
                            blurRadius: 3
                          ),
                          BoxShadow(
                              offset: Offset(-0.1, 0.1),
                              color: Colors.grey[400],
                              spreadRadius: 0.5,
                              blurRadius: 3
                          )
                        ]
                      ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                          child: TextField(
                            controller: _textController,
                            focusNode: _textNode,
                            decoration: InputDecoration(
                                icon: _userAvatar(localUser: true,users: user[0]),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Visibility(
                                      visible: _isEditingContent,
                                      child: IconButton(
                                        icon: Icon(Icons.cancel, color: Colors.grey[400],),
                                        onPressed: (){
                                          setState(() {
                                            _isEditingContent = false;
                                            _textController.text = '';
                                          });
                                        },
                                      )
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.send, color: Colors.grey[400],),
                                      onPressed: (){
                                        if(_textController.text != null && _textController.text != ''){
                                          if(!_isEditingContent){
                                            print('object');
                                            FirestoreService().addComment(uid: user[0].uid, id:  widget.docId, message: _textController.text,visible: true);
                                            setState(() {
                                              _textController.text = '';
                                              _isEditingContent = false;
                                            });
                                          }else{
                                            FirestoreService().updateComment(id:  widget.docId, message: _textController.text, docId: _editingIndex).then((value){
                                              Widgets().snackBar(scaffoldGlobalKey: scaffoldGlobalKey,message: 'Comentario actualizado.', textColor: Colors.white.withOpacity(0.8), color: Colors.black.withOpacity(0.8));
                                            }).catchError((error){
                                              Widgets().snackBar(scaffoldGlobalKey: scaffoldGlobalKey,message: 'Se ha presentado un error, intente de nuevo mas tarde.', textColor: Colors.white.withOpacity(0.8), color: Colors.black.withOpacity(0.8));
                                            });
                                            _textController.text = '';
                                            _isEditingContent = false;
                                          }
                                        }
                                      },
                                    )
                                  ],
                                ),
                                hintText: 'Comentar',
                                hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                                border: InputBorder.none
                            ),
                            maxLines: 10,
                            minLines: 1,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                                fontSize: 16
                            ),
                          )
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Container(
                                height: 6,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey[400].withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              padding: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 2,
                                          color: Colors.grey[400].withOpacity(0.7)
                                      )
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.favorite, color: Colors.red,size: 25,),
                                      SizedBox(width: 15,),
                                      Text(
                                        widget.likeCount,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14
                                        ),
                                      ),
                                      SizedBox(width: 30,),
                                      ImageIcon(
                                          AssetImage('icons/comentario.png'),
                                          color: //Colors.black
                                          Colors.grey[600]
                                      ),
                                      SizedBox(width: 15,),
                                      Text(
                                        stream != null ?  (stream.length-1).toString() : '0',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                          ],
                        )
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  //TODO: userAvatar
  Widget _userAvatar({users, indexName, localUser}){
    return Container(
        child: CachedNetworkImage(
          imageUrl: localUser ? users.photoUrl :users[indexName].photoUrl,
          filterQuality: FilterQuality.high,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red),backgroundColor: Colors.grey[850],strokeWidth: 3, value: downloadProgress.progress,),
              ),
          placeholder: (context, url){
            return Container(
              child: CircularProgressIndicator(),
            );
          },
          imageBuilder: (context, url){
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  image: DecorationImage(
                      image: url,
                      fit: BoxFit.cover
                  ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[500],
                      blurRadius: 0.5,
                      spreadRadius: 0.5,
                      offset: Offset(0, 1.5)
                  )
                ]
              ),
            );
          },
        )
    );
  }

  //TODO admin bottomSheet
  void adminSheet({context, docId, galleryPath, galleryCount, index, uid, content}){
    final user = Provider.of<List<User>>(context, listen: false);
    _textNode.unfocus();
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: 200.1,
              decoration: BoxDecoration(
                color: //Colors.grey[200],
                Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 8),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                              color: //Colors.grey[300]
                              Colors.grey[600],
                              borderRadius: BorderRadius.circular(10)
                          ),
                        )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20,top: 40,left: 10,right: 10),
                    child: Column(
                      children: <Widget>[
                        adminContainer(title: 'Eliminar comentario', icon: Icons.delete, onTap: () async{
                          print('eli comentario');
                          FirestoreService().deleteComment(id: widget.docId, docId: docId).then((value){
                            Widgets().snackBar(scaffoldGlobalKey: scaffoldGlobalKey,message: 'Comentario eliminado.', textColor: Colors.black.withOpacity(0.8), color: Colors.white.withOpacity(0.8));
                            Navigator.of(context).pop();
                          }).catchError((error){
                            Widgets().snackBar(scaffoldGlobalKey: scaffoldGlobalKey,message: 'Se ha presentado un error, intente de nuevo mas tarde.', textColor: Colors.black.withOpacity(0.8), color: Colors.white.withOpacity(0.8));
                          });

                        }),
                        Visibility(
                          visible: user[0].uid == uid,
                          child: adminContainer(title: 'Actualizar comentario', icon: Icons.edit, onTap: (){
                            print('edit comentario');
                            setState(() {
                              _isEditingContent = true;
                              _textController.text = content;
                              _editingIndex = docId;
                            });
                            Navigator.of(context).pop();
                          }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
  adminContainer({title, onTap, icon}){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.grey[300],size: 25,),
        title: Text(
          title,
          style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
              fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}