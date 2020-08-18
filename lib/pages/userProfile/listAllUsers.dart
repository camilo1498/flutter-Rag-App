import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/pages/userProfile/userDetailPage.dart';
import 'package:ragapp/utils/Widgets/AnimatedPageRoute/MaterialFadeTransition.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';

class ListAllUsers extends StatefulWidget {
  @override
  _ListAllUsersState createState() => _ListAllUsersState();
}

class _ListAllUsersState extends State<ListAllUsers> {
  //TODO: objects
  FirestoreService _firestoreService = FirestoreService();
  Widgets _widgets = Widgets();
  //TODO: variables
  bool _isSearch = false;
  var _search = '';
  //TODO: Controllers
  var textController = TextEditingController();
  var textFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
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
          'Todos los usuarios',
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
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Padding(
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
                      hintText: 'Buscar Usuario',
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
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: _size.width,
                  height: _size.height * 0.82,
                  child: StreamBuilder(
                    stream: _firestoreService.SearchUser(searchIndex: _search, searchByMinisterio: '',isService: false,isAdmin: false),
                    builder: (context, snapshot){
                      return snapshot.data != null ? Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: _size.aspectRatio >= 0.46 && _size.aspectRatio < 0.6 ? _size.aspectRatio * 1.78 : _size.aspectRatio * 1.65,
                            ),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index){
                              return InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: (){
                                  Navigator.push(context, FadePageRoute(builder: (context) => userDetailPage(documentId: snapshot.data[index].uid, servidores: false,)));
                                },
                                child: Hero(
                                  tag: snapshot.data[index].uid,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey[500],
                                            blurRadius: 0.5,
                                            spreadRadius: 0.5,
                                            offset: Offset(0, 1.5)
                                          )
                                        ]
                                      ),
                                      child: _widgets.userCard(
                                          isService: false,
                                          index: index,
                                          currentMinisterio: '',
                                          ministerio: '',
                                          size: _size,
                                          snapshot: snapshot
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
