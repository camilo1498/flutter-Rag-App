import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/models/userModel.dart';
import 'package:ragapp/pages/Anuncios/AnunciosPage.dart';
import 'package:ragapp/pages/Anuncios/createPublicacion.dart';
import 'package:ragapp/pages/Yotube/predicationScreen.dart';
import 'package:ragapp/pages/ministerios/Ministerios.dart';
import 'package:ragapp/pages/userProfile/Admistradores.dart';
import 'package:ragapp/pages/userProfile/Servidores.dart';
import 'package:ragapp/pages/userProfile/listAllUsers.dart';
import 'package:ragapp/pages/userProfile/notifications.dart';
import 'package:ragapp/pages/userProfile/userDetailPage.dart';
import 'package:ragapp/provider/logOutprovider.dart';
import 'package:ragapp/provider/rigthMenuProvider.dart';
import 'package:ragapp/utils/Widgets/AnimatedPageRoute/MaterialFadeTransition.dart';
import 'package:ragapp/utils/Widgets/NavigationBottomBar/animated_bottom_bar.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  //TODO: bottom bar
  final List<BarItem> barItems = [
    BarItem(
      text: "",
      iconData: 'icons/menu.png',
      color: Colors.white,

    ),
    BarItem(
      text: "",
      iconData: 'icons/youtube.png',
      color: Colors.white,
    ),
    BarItem(
      text: "Inicio",
      iconData: 'icons/home.png',
      color: Colors.white,
    ),
    BarItem(
      text: "",
      iconData: 'icons/notificationBell.png',
      color: Colors.white,
    ),

  ];
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  //TODO:objects
  Widgets _widgets = Widgets();

  //TODO: controllers
  AnimationController controller;
  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();

  //TODO: OPEN LINKS ON ANOTHER APP
  _launchURL(url) async {
    print('launch url!');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
  }
  int selectedIndex = 2;
  int lastIndex = 2;

  @override
  Widget build(BuildContext context) {
    const double _fabDimension = 37.0;

    //TODO: definir estado del menu
    final signOut = Provider.of<LogOutProvider>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);
    final userRole = Provider.of<List<User>>(context);
    final state = Provider.of<rightMenuProvider>(context,listen: false);

    List<Widget> pageRoute = [
      Container(),
      PredicationScreen(),
      TopScrollScreenEffect(),
      Notifications()
    ];
    //TODO: onbackPressed
    Future<bool> response(){
      return _widgets.onBackPressedWithRoute(
          user: user,
          dismissible: true,
          context: context,
          title: 'Cerrar Sesión',
          fontSize: 13,
          message: 'Esta seguro de cerrar sesión?',
          singOut: true,
          route: null
      );
    }
    return userRole != null && userRole.length >0 ? WillPopScope(
      onWillPop: response,
      child: Scaffold(
        body: !signOut.state ? InnerDrawer(
          key: _innerDrawerKey,
            leftOffset: -0.7,
            onTapClose: true,
            backgroundColor: Colors.grey[850],
            swipe: false,
            tapScaffoldEnabled: true,
            proportionalChildArea: false,
            //backgroundColor: Colors.red,
            colorTransition: Colors.grey,
            leftAnimationType: InnerDrawerAnimation.static,
            //menu lateral izquierdo

            //selectedIndex == 0 ? pageRoute[lastIndex] : pageRoute[selectedIndex],
          scaffold: Stack(
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child:  IndexedStack(
                  children: pageRoute,
                  index: selectedIndex == 0 ? lastIndex : selectedIndex,
                )
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedBottomBar(
                  barItems: widget.barItems,
                  lastIndex: lastIndex,
                  profile: InkWell(
                    borderRadius: BorderRadius.circular(_fabDimension),
                    onTap: (){
                      Navigator.push(context, FadePageRoute(builder: (context) => userDetailPage(documentId: user.uid, servidores: false,)));
                    },
                    child: SizedBox(
                        height: _fabDimension,
                        width: _fabDimension,
                        child: Hero(
                          tag: userRole[0].uid,
                          child: Container(
                            height: _fabDimension,
                            width: _fabDimension,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(_fabDimension)
                            ),
                            child: userRole != null ? CachedNetworkImage(
                              imageUrl: userRole[0].photoUrl,
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.cover,
                              placeholder: (context, url){
                                return CircularProgressIndicator(
                                  strokeWidth: 2,
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation(Colors.red),
                                );
                              },
                              imageBuilder: (context, url){
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(_fabDimension),
                                      image: DecorationImage(
                                          image: url,
                                          fit: BoxFit.cover
                                      )
                                  ),
                                );
                              },
                            ) : Container(
                              padding: EdgeInsets.all(2),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.red),
                                backgroundColor: Colors.grey[850],
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        )
                    ),
                  ),
                  animationDuration: Duration(milliseconds: 400),
                  barStyle: BarStyle(
                    fontSize: 20,
                    iconSize: 30,
                  ),
                  onBarTap: (index){
                    setState(() {
                      if(selectedIndex == 0){

                      }else{
                        lastIndex = selectedIndex;
                      }
                      if(index == 0){
                        selectedIndex = lastIndex;
                        if(_innerDrawerKey.currentContext !=null){
                          _innerDrawerKey.currentState.toggle();
                        }
                      }else{
                        selectedIndex = lastIndex;
                        state.state = false;
                        _innerDrawerKey.currentState.close();
                      }
                      selectedIndex = index;
                      print(lastIndex);
                      print(selectedIndex);
                    });
                  },
                ),
              )
            ],
          ),
          leftChild: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 9),
            color: Colors.grey[850],
            child: Stack(
              alignment: Alignment.topLeft,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          _launchURL('https://www.facebook.com/RedAlcanceGlobalicc/');
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                  image: AssetImage('icons/facebook.png')
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      InkWell(
                        onTap: (){
                          _launchURL('https://www.instagram.com/alcanceglobalicc/');
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('icons/instagram.png')
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 8,),
                      InkWell(
                        onTap: (){
                          _launchURL('https://www.youtube.com/user/AlcanceGlobal');
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('icons/youtubeColor.png')
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 80, horizontal: 9),
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                            onTap: (){
                              Navigator.push(context, FadePageRoute(builder: (context) => Servidores()));
                            },
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ImageIcon(AssetImage('icons/servidores.png'),color: Colors.grey[200],size: 22,),
                                  SizedBox(width: 5,),
                                  Text(
                                    "Servidores",
                                    style: TextStyle(
                                        color: Colors.white,
                                      fontSize: 13
                                    ),
                                  ),
                                ],
                              )
                            ),
                          ),
                          SizedBox(width: 30,),
                          InkWell(
                            onTap: (){
                            },
                            child: Container(
                              child: Row(
                               mainAxisSize: MainAxisSize.min,
                               children: <Widget>[
                                 ImageIcon(AssetImage('icons/contacto.png'),color: Colors.grey[200],size: 22,),
                                 SizedBox(width: 5,),
                                 Text(
                                   "Contacto",
                                   style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 13
                                   ),)
                                 ,
                               ],
                              )
                            ),
                          ),
                          SizedBox(width: 30,),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, FadePageRoute(builder: (context) => Ministerios()));
                            },
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  ImageIcon(AssetImage('icons/altar.png'),color: Colors.grey[200],size: 22,),
                                  SizedBox(width: 5,),
                                  Text(
                                    "Ministerios",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ),
                Visibility(
                  visible: userRole != null,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: userRole[0].isAdmin? InkWell(
                      onTap: (){
                        _widgets.AdminSheet(
                            context: context,
                            tree: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  adminContainer(
                                      onTap: (){
                                        Navigator.pop(context);
                                        Navigator.push(context, FadePageRoute(builder: (context) => CreatePublicacion(isEditing: false,content: null,uid: null,index: null,docId: null,)));
                                      },
                                      icon: ImageIcon(AssetImage('icons/anuncio.png'),color: Colors.grey[200],),
                                      title: 'Crear Anuncio'
                                  ),
                                  adminContainer(
                                      onTap: (){
                                        Navigator.pop(context);
                                        //Navigator.push(context, FadePageRoute(builder: (context) => ));
                                      },
                                      icon: ImageIcon(AssetImage('icons/notificacion.png'),color: Colors.grey[200],),
                                      title: 'Crear Notificación'
                                  ),

                                  adminContainer(
                                      onTap: (){
                                        Navigator.pop(context);
                                        Navigator.push(context, FadePageRoute(builder: (context) => ListAllUsers()));
                                      },
                                      icon: ImageIcon(AssetImage('icons/servidores.png'),color: Colors.grey[200],),
                                      title: 'Listar todos los usuarios'
                                  ),
                                  adminContainer(
                                      onTap: (){
                                        Navigator.pop(context);
                                        Navigator.push(context, FadePageRoute(builder: (context) => Administradores()));
                                      },
                                      icon: ImageIcon(AssetImage('icons/administrador.png'),color: Colors.grey[200],),
                                      title: 'Administradores'
                                  ),

                                ],
                              ),
                            )
                        );
                      },
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: ImageIcon(AssetImage('icons/ajustes.png'),color: Colors.grey[200],size: 23,),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                "Admin",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: ImageIcon(AssetImage('images/logonotificacion.png'), color: Colors.grey[200],size: 25,),
                        ),
                  ),
                )
              ],
            ),
          )
        ): _widgets.showCircularProgressIndicator(
            context: context,
            color: Colors.grey[850],
            text: 'Cerrando Sesión \nespere un momento'
        ),

      ),
    )
    : Material(
      color: Colors.grey[200],
      child: _widgets.showCircularProgressIndicator(
          context: context,
          color: Colors.grey[200],
          text: 'Cargando...'
      ),
    );
  }
  adminContainer({title, onTap, icon}){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(

          width: MediaQuery.of(context).size.width,
          height: 60,
          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 25),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 25,
                width: 25,
                child: icon,
              ),
              SizedBox(width: 25,),
              Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[200]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}