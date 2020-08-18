import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/models/MinisterioModel.dart';
import 'package:ragapp/models/userModel.dart';
import 'package:ragapp/pages/ministerios/CUMinisterio.dart';
import 'package:ragapp/pages/ministerios/MinisterioPage.dart';
import 'package:ragapp/utils/Widgets/AnimatedPageRoute/MaterialFadeTransition.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';

class Ministerios extends StatefulWidget {
  @override
  _MinisteriosState createState() => _MinisteriosState();
}

class _MinisteriosState extends State<Ministerios> with TickerProviderStateMixin {
  //TODO: global keys
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  //TODO: controllers
  Widgets _widgets = Widgets();

  Future<bool> delete({message, title}) {
    return _widgets.onBackPressedWithRoute(
        dismissible: true,
        context: context,
        title: title,
        fontSize: 13,
        message: message,
        singOut: false,
        route: null
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _ministerio = Provider.of<List<Ministerio>>(context);
    final userRole = Provider.of<List<User>>(context);
    return Scaffold(
      backgroundColor: Colors.grey[350],
      key: scaffoldGlobalKey,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          'Ministerios',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: //Colors.black
              Colors.white
          ),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
                Icons.arrow_back_ios,
                color: //Colors.black
                Colors.white
            )
        ),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child: ListView.builder(
          itemCount: _ministerio != null ? _ministerio.length : 0,
          itemBuilder: (context, index){
            return MinisteriosPage(
              index: index,
              userRole: userRole,
              ministerio: _ministerio,
              scaffoldKey: scaffoldGlobalKey,
            );
          },
        ),
      ),
      floatingActionButton: Visibility(
        visible: userRole[0].isAdmin,
        child: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, FadePageRoute(builder: (context) => CUMinisterio(editing: false)));
          },
          child: Icon(Icons.add, color: Colors.white,),
        ),
      ),
    );
  }

}