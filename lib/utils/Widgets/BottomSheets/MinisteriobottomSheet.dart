import 'package:flutter/material.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';
class MinisterioBottomSheet extends StatefulWidget {
  final ministerios;
  final userMinisterio;
  final currentMinisterio;
  MinisterioBottomSheet({this.userMinisterio, this.ministerios, this.currentMinisterio});
  @override
  _MinisterioBottomSheetState createState() => _MinisterioBottomSheetState();
}

class _MinisterioBottomSheetState extends State<MinisterioBottomSheet> {
  //TODO: global keys
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  //TODO: objects
  FirestoreService _firestoreService = FirestoreService();
  Widgets _widgets = Widgets();
  //TODO: variables
  var output1;
  var currentMinisterio;
  var userMinisterio;
  var ministerios;
  bool checkingMinisterio = false;
  bool success = false;
  var response;
  var selectedIndex;
  var selectedMinisterio;
  var uid;
  List first;
  List second;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentMinisterio = widget.currentMinisterio;
    userMinisterio = widget.userMinisterio.ministerios;
    ministerios = widget.ministerios;
    first =  widget.currentMinisterio;
    second = widget.userMinisterio.ministerios;
    output1 = first.where((element) => second.contains(element));
    uid = widget.userMinisterio.uid;
  }
  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Container(
                height: 8,
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10,left: 20, right: 20),
              //TODO: title
              child: Text(
                'Ministerio',
                style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                ),
              ),
            ),
            //TODO: data
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,),
              height: 310,
              color: Colors.white,
              child: Scaffold(
                key: scaffoldGlobalKey,
                backgroundColor: Colors.white,
                body: ListView.builder(
                  itemBuilder: (context, index){
                    return ListTile(
                      title: Text(
                        ministerios[index].name,
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      leading: ImageIcon(NetworkImage(ministerios[index].imageUrl),size: 30,color: Colors.grey[900],),
                      trailing: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: index == selectedIndex && success? Colors.white
                                : index == selectedIndex  && checkingMinisterio ? Colors.white
                                : output1.contains(ministerios[index].id) ? Colors.red
                                : Colors.green,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: InkWell(
                            onTap: () async{
                              if(checkingMinisterio){

                              }else{
                                setState(() {
                                  checkingMinisterio = true;
                                  selectedMinisterio = ministerios[index].id;
                                  selectedIndex = index;
                                });

                                await Future.delayed(Duration(milliseconds: 1500));
                                await _firestoreService.updateUserMinisterio(ministerio: selectedMinisterio, uid: uid, ).then((value) async{
                                  setState(() {
                                    success = true;
                                    checkingMinisterio = false;
                                    selectedMinisterio = null;
                                  });
                                  _widgets.snackBar(
                                      scaffoldGlobalKey: scaffoldGlobalKey,
                                      message: 'El ministerio se ha añadido / eliminado correctamente',
                                      color: Colors.black.withOpacity(0.92),
                                      textColor: Colors.white
                                  );
                                  await Future.delayed(Duration(milliseconds: 2500));
                                  Navigator.of(context).pop();
                                }).catchError((e) async{
                                  setState(() {
                                    success = false;
                                    checkingMinisterio = false;
                                    selectedMinisterio = null;
                                  });
                                  _widgets.snackBar(
                                      scaffoldGlobalKey: scaffoldGlobalKey,
                                      message: 'Error, intente de nuevo mas tarde',
                                      color: Colors.black.withOpacity(0.92),
                                      textColor: Colors.white
                                  );
                                  await Future.delayed(Duration(milliseconds: 2500));
                                  Navigator.of(context).pop();
                                });
                              }
                            },
                            child: success && index == selectedIndex ?  Icon(Icons.check, color: Colors.green, size: 20,) : index == selectedIndex  && checkingMinisterio ? Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.grey[850]),strokeWidth: 2,backgroundColor: Colors.red,),
                            )
                                : Icon(
                              output1.contains(ministerios[index].id) ?
                              Icons.delete :
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            )

                        ),
                      ),
                    );
                  },
                  itemCount:ministerios.length,
                ),
              ),
            ),
          ],
        )
    );
  }
}