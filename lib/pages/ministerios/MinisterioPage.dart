import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/pages/ministerios/CUMinisterio.dart';
import 'package:ragapp/utils/Widgets/AnimatedPageRoute/MaterialFadeTransition.dart';
import 'package:ragapp/utils/Widgets/CustomDialog.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';

class MinisteriosPage extends StatefulWidget {
  final ministerio;
  final index;
  final userRole;
  final scaffoldKey;
  MinisteriosPage({this.userRole,this.index,this.ministerio, this.scaffoldKey});
  @override
  _MinisteriosPageState createState() => _MinisteriosPageState();
}

class _MinisteriosPageState extends State<MinisteriosPage> with TickerProviderStateMixin{
  //TODO: variables
  bool isOpen = false;
  List _userList = [];
  String message = '';
  //TODO: instances
  Widgets _widgets = Widgets();
  Future<bool> delete({name, deleteUser}){
    return _widgets.onBackPressedWithRoute(
        dismissible: true,
        context: context,
        title: deleteUser ? 'Eliminar Lider' : 'Eliminar Ministerio',
        fontSize: 13,
        message: deleteUser ? 'Está seguro de eliminar este ministerio?' : 'Está seguro de eliminar el ministerio de $name? Se perderán todos los datos.',
        singOut: false,
        route: null
    );
  }
  @override
  Widget build(BuildContext context) {
    //TODO: progress dialog indicator
    var pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(
      backgroundColor: Colors.white,
      borderRadius: 10,
      elevation: 10,
      progressWidget: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red),backgroundColor: Colors.grey[850],strokeWidth: 3,),
      ),
      message: message,
      messageTextStyle: TextStyle(
      ),
    );
    final users = Provider.of<List>(context);
    _userList.clear();
    for(int i = 0; i <= users.length -1; i++){
     _userList.add(users[i].uid);
    }
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: //TODO: has leader and description
      isOpen && widget.ministerio[widget.index].leaderList != null && widget.ministerio[widget.index].leaderList.length != 0 && widget.ministerio[widget.index].description != null && widget.ministerio[widget.index].description != ''
          ? (widget.ministerio[widget.index].leaderList.length+2.5) * 75.1

              //TODO: has leader but doesn't description
          : isOpen && widget.ministerio[widget.index].leaderList != null && widget.ministerio[widget.index].leaderList.length != 0 && widget.ministerio[widget.index].description == ''
          ? 2.5 * 75.1

              //TODO: has description but doesn't leader
          : isOpen && widget.ministerio[widget.index].leaderList.length == 0 && widget.ministerio[widget.index].description != null && widget.ministerio[widget.index].description != ''
          ? 2.5 * 75.1
             //TODO: it has neither
          : isOpen && widget.ministerio[widget.index].leaderList == null || widget.ministerio[widget.index].leaderList.length == 0 && widget.ministerio[widget.index].description == null || widget.ministerio[widget.index].description == ''
          ? 75.1
          : 75.1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15,),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[700],
                    blurRadius: 0.1,
                    spreadRadius: 0.1,
                    offset: Offset(0, 0.5)
                )
              ]
          ),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: ImageIcon(
                    NetworkImage(widget.ministerio[widget.index].imageUrl),
                    color: Colors.black,
                    size: 30,
                  ),
                  title: Text(
                    widget.ministerio[widget.index].name,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: //Colors.black
                        Colors.grey[900]
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () async{
                          setState(() {
                            message = 'Eliminando.';
                            isOpen = false;
                          });
                          var _delete = await delete(name: widget.ministerio[widget.index].name.toString(), deleteUser: false);
                          if(_delete){
                            await pr.show();
                            var _res = await Future.delayed(Duration(milliseconds: 3000)).then((value) => FirestoreService().deleteMinisterio(widget.ministerio[widget.index].id));
                            if(_res){
                              await pr.hide();
                              _widgets.snackBar(
                                  scaffoldGlobalKey: widget.scaffoldKey,
                                  color: Colors.black.withOpacity(0.8),
                                  textColor: Colors.white.withOpacity(0.8),
                                  message: 'Ministerio eliminado.'
                              );
                            }else{
                              await pr.hide();
                              _widgets.snackBar(
                                  scaffoldGlobalKey: widget.scaffoldKey,
                                  color: Colors.black.withOpacity(0.8),
                                  textColor: Colors.white.withOpacity(0.8),
                                  message: 'Error al eliminar.'
                              );
                            }
                          }
                        },
                        child: Visibility(
                          visible: widget.userRole[0].isAdmin,
                          child: Icon(
                            Icons.delete,
                            size: 25,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: () {
                          isOpen = false;
                          Navigator.push(context, FadePageRoute(builder: (context) => CUMinisterio(
                            editing: true,
                            url: widget.ministerio[widget.index].imageUrl,
                            name: widget.ministerio[widget.index].name,
                            desc: widget.ministerio[widget.index].description,
                            leaderList: widget.ministerio[widget.index].leaderList,
                            docId: widget.ministerio[widget.index].id,
                          )));
                        },
                        child: Visibility(
                          visible: widget.userRole[0].isAdmin,
                          child: Icon(
                            Icons.edit,
                            size: 25,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: (){
                          setState(() {
                            isOpen = !isOpen;
                          });
                        },
                        child: Visibility(
                          visible://TODO: has leader and description
                          widget.ministerio[widget.index].leaderList != null && widget.ministerio[widget.index].leaderList.length != 0 && widget.ministerio[widget.index].description != null && widget.ministerio[widget.index].description != ''
                              ? true
                          //TODO: has leader but doesn't description
                              : widget.ministerio[widget.index].leaderList != null && widget.ministerio[widget.index].leaderList.length != 0 && widget.ministerio[widget.index].description == ''
                              ? true

                          //TODO: has description but doesn't leader
                              : widget.ministerio[widget.index].leaderList == null || widget.ministerio[widget.index].leaderList.length == 0 && widget.ministerio[widget.index].description != null && widget.ministerio[widget.index].description != ''
                              ? true
                          //TODO: it has neither
                              : widget.ministerio[widget.index].leaderList == null || widget.ministerio[widget.index].leaderList.length == 0 && widget.ministerio[widget.index].description == null || widget.ministerio[widget.index].description == ''
                              ? false : false,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 25,
                            color: Colors.grey[900],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    color: Colors.grey[500],
                    height: 1,
                    width: isOpen ? MediaQuery.of(context).size.width : 0,
                  ),
                ),
                SizedBox(height: 10,),
                Visibility(
                  visible: widget.ministerio[widget.index].description != null &&  widget.ministerio[widget.index].description != '',
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[500], width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                      child: Text(
                        widget.ministerio[widget.index].description,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: //Colors.black
                            Colors.grey[900]
                        ),
                      )
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.ministerio[widget.index].leaderList != null && widget.ministerio[widget.index].leaderList.length != 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Lideres',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: //Colors.black
                            Colors.grey[500]
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.ministerio[widget.index].leaderList != null && widget.ministerio[widget.index].leaderList.length != 0,
                  child: Container(
                    height: widget.ministerio[widget.index].leaderList != null && widget.ministerio[widget.index].leaderList.length != 0 ? widget.ministerio[widget.index].leaderList.length * 75.1 : 0.0,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: widget.ministerio[widget.index].leaderList.length,
                      itemBuilder: (context, index){
                        var indexName = _userList.indexOf(widget.ministerio[widget.index].leaderList[index]);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[500],
                                      blurRadius: 0.1,
                                      spreadRadius: 0.1,
                                      offset: Offset(0, 2)
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(90),
                                  image: DecorationImage(
                                    image: NetworkImage( users[indexName].photoUrl),
                                    fit: BoxFit.cover
                                  )
                                ),
                                height: 45,
                                width: 45,
                              ),
                              title:  Text(
                                users[indexName].name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: //Colors.black
                                    Colors.grey[900]
                                ),
                              ),
                              trailing: InkWell(
                                onTap: () async{
                                  setState(() {
                                    message = 'Eliminando.';
                                  });
                                  var _delete = await delete(name: '', deleteUser: true);
                                  if(_delete){
                                    await pr.show();
                                    var _res = await Future.delayed(Duration(milliseconds: 3000)).then((value) => FirestoreService().deleteUserLeader(docId: widget.ministerio[widget.index].id, uid: users[indexName].uid));
                                    if(_res){
                                      await pr.hide();
                                      _widgets.snackBar(
                                          scaffoldGlobalKey: widget.scaffoldKey,
                                          color: Colors.black.withOpacity(0.8),
                                          textColor: Colors.white.withOpacity(0.8),
                                          message: 'Lider eliminado.'
                                      );
                                      setState(() {
                                        isOpen = false;
                                      });
                                    }else{
                                      await pr.hide();
                                      _widgets.snackBar(
                                          scaffoldGlobalKey: widget.scaffoldKey,
                                          color: Colors.black.withOpacity(0.8),
                                          textColor: Colors.white.withOpacity(0.8),
                                          message: 'Error al eliminar.'
                                      );
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Visibility(
                                    visible: widget.userRole[0].isAdmin,
                                    child: Icon(
                                      Icons.delete,
                                      size: 25,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 70,right: 40,bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 1,color: Colors.grey[500].withOpacity(0.7)
                                    )
                                  )
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}