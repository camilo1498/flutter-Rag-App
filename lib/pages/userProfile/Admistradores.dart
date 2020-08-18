import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/models/userModel.dart';

class Administradores extends StatefulWidget {
  @override
  _AdministradoresState createState() => _AdministradoresState();
}

class _AdministradoresState extends State<Administradores> with TickerProviderStateMixin{
  //TODO: objects
  FirestoreService _firestoreService = FirestoreService();
  //TODO: variables
  bool _isSearch = false;
  var _search = '';
  //TODO: Controllers
  var textController = TextEditingController();
  var textFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    final userRole = Provider.of<List<User>>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: //Colors.white,
        Colors.grey[900],
        centerTitle: false,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.white,),
        ),
        title: Text(
          'Administradores',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: //Colors.black
              Colors.white
          ),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: ImageIcon(
              AssetImage(
                'images/logonotificacion.png',
              ),
              color: //Colors.black,
              Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Visibility(
              visible: _isSearch,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500],width: 1),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                  child: TextField(
                    controller: textController,
                    focusNode: textFocus,
                    maxLines: 1,
                    onChanged: (value){
                      setState(() {
                        _search = value;
                      });
                    },
                    style: TextStyle(
                        fontFamily: 'Glenn Slab',
                        fontWeight: FontWeight.w400,
                        fontSize: 20
                    ),
                    decoration: InputDecoration(
                        hintText: 'Buscar usuario',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500],
                            fontSize: 18
                        ),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, size: 30, color: Colors.grey[500],)
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: !_isSearch ? EdgeInsets.only(top: 35) : EdgeInsets.only(top: 10),
              child: StreamBuilder(
                stream: _firestoreService.SearchUser(searchIndex: _search, searchByMinisterio: '',isService: false, isAdmin: _isSearch ? false :true),
                builder: (context, snapshot){
                  return snapshot.data != null ? AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: snapshot.data.length * 70.1,
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index){
                        return InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15,right: 15),
                            child: Container(
                              width: _size.width,
                              height: 70,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                              child: CachedNetworkImage(
                                                imageUrl: snapshot.data[index].photoUrl,
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
                                                    width: 51,
                                                    height: 51,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(90),
                                                        image: DecorationImage(
                                                            image: url,
                                                            fit: BoxFit.cover
                                                        )
                                                    ),
                                                  );
                                                },
                                              )
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            width: 250,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                //TODO: user name
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    snapshot.data[index].name,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w700,
                                                        wordSpacing: 0,
                                                        letterSpacing: 0,
                                                        fontFamily: 'Glenn Slab'
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                //TODO: user state
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child:AnimatedSize(
                                                    duration: Duration(milliseconds: 300),
                                                    vsync: this,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Visibility(
                                                          visible: snapshot.data[index].isAdmin,
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                              Container(
                                                                 decoration: BoxDecoration(
                                                                   color: Colors.black,
                                                                   borderRadius: BorderRadius.circular(40)
                                                                 ),
                                                                 padding: EdgeInsets.all(1),
                                                                 child: Icon(Icons.star, color: Colors.yellow, size: 12,)
                                                              ),
                                                              Text(' Admin /',
                                                                style: TextStyle(
                                                                    color: Colors.black
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Visibility( visible: snapshot.data[index].isAdmin,child: SizedBox(width: 3,)),
                                                        Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: <Widget>[
                                                            Material(
                                                              type: MaterialType.circle,
                                                              color: snapshot.data[index].isOnline ? Colors.green : Colors.red,
                                                              child: Container(
                                                                height: 10,
                                                                width: 10,
                                                              ),
                                                            ),
                                                            SizedBox(width: 3,),
                                                            Text(snapshot.data[index].isOnline ? 'Online' : 'Offline',
                                                              style: TextStyle(
                                                                  color: Colors.black
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: userRole[0].isAdmin,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            children: <Widget>[
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                onTap: () async{
                                                  await _firestoreService.updateUserdata(
                                                      field: 'isAdmin',
                                                      uid: snapshot.data[index].uid,
                                                      data: snapshot.data[index].isAdmin ? 'false' : 'true'
                                                  );
                                                },
                                                child: AnimatedContainer(
                                                  duration: Duration(milliseconds: 500),
                                                  height: 25,
                                                  width: 25,
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: snapshot.data[index].isAdmin ? Colors.red : Colors.green,
                                                    borderRadius: BorderRadius.circular(4)
                                                  ),
                                                  child: Icon(snapshot.data[index].isAdmin ? Icons.delete : Icons.add, color: Colors.white,size: 18,),
                                                ),
                                              ),
                                            ],
                                          )
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    indent: 60,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                      : Container(
                    height: 350,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.error_outline, color: Colors.black38.withOpacity(0.2),size: 100,),
                          SizedBox(height: 5,),
                          Text(
                            'Sin resultados',
                            style: TextStyle(
                                color: Colors.black38.withOpacity(0.2),
                                fontSize: 15
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState(() {
              _isSearch = !_isSearch;
              _search = '';
              textController.text = '';
              textFocus.unfocus();
            });
          },
          child: Container(
            width: 45,
            height: 45,
            child: _isSearch ? Icon(Icons.settings_backup_restore,color: Colors.white,) : Icon(Icons.add,color: Colors.white,),
          )
      ),
    );
  }
}