import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/auth.dart';
import 'package:ragapp/pages/Clips/Clipper.dart';
import 'package:ragapp/provider/logOutprovider.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //TODO: variables
  bool _isRegister = false;
  bool _validate = false;
  bool _loading = false;

  bool _validateName = false;
  bool _validateLastName = false;
  bool _validateEmail = false;
  bool _validatePass = false;
  bool _validatePass2 = false;

  bool _isObscure = true;
  bool _isObscure2 = true;

  String message4 = '';
  String message5 = '';

  //TODO: controllers
  var _nameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passController = TextEditingController();
  var _pass2Controller = TextEditingController();

  //TODO: focus node
  var _nameNode = FocusNode();
  var _lastNameNode = FocusNode();
  var _emailNode = FocusNode();
  var _passNode = FocusNode();
  var _pass2Node = FocusNode();

  //TODO: global keys
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //TODO: validation
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      setState(() {
        _validateEmail = false;
      });
      return null;
    }
    else{
      setState(() {
        _validateEmail = true;
      });
      return null;
    }
  }
  //TODO: pasar entre las cajas de texto mediante el teclado
  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus){
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  //TODO: instances
  final AuthService _authService = AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //default value : width : 1080px , height:1920px , allowFontScaling:false
    ScreenUtil.init(context);
//If you want to set the font size is scaled according to the system's "font size" assist option
    ScreenUtil.init(context, width: 720, height: 1080, allowFontScaling: true);
    var _size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      key: scaffoldGlobalKey,
      body: Container(
        width: _size.width,
        height: _size.height,
        child: Stack(
          children: <Widget>[
            //TODO: leftCircle
            leftImage(size: _size),
            rightImage(size: _size),
            rightBottomImage(size: _size),
            SingleChildScrollView(
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(400),
                      child: Stack(
                        children: <Widget>[
                          //TODO: top image painter
                          topImagePainter(),
                          //TODO: logo
                          logo(),
                          //TODO: title
                          title()
                        ],
                      ),
                    ),
                    //TODO: text fields
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 0, bottom: 20),
                      child: AnimatedContainer(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 600),
                          height: _isRegister ? 6 * 93.0 : 2 * 130.0,
                          width: _size.width,
                          margin: EdgeInsets.only(top: 40),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                    offset: Offset(0, 1)
                                )
                              ]
                          ),
                          child: Center(
                            child: _isRegister ? signUp() : signIn(),
                          )
                      ),
                    ),
                    //TODO: social login / signIn button
                    loginButtons(authService: _authService, size: _size),
                    SizedBox(height:
                    _isRegister ? //TODO: height >=790
                    _size.height >= 790 ? _size.width * 0.09
                    //TODO: height < 790
                        : _size.width * 0.055 : //TODO: height >=790
                    _size.height >= 790 ? _size.width * 0.25
                    //TODO: height < 790
                        : _size.width * 0.075,),
                    registerButton(),
                    SizedBox(height: 50,)
                  ],
                ),
              ),
            ),
            _loading ? Center(
              child: Container(
                width: _size.width,
                height: _size.height,
                color: Colors.black.withOpacity(0.5),
              ),
            ) : Container()
          ],
        ),
      ),
    );
  }

//TODO: top image painter
  Widget topImage() {
    return Positioned(
        child: CustomPaint(
          child: Container(
            decoration: BoxDecoration(
            ),
            height: ScreenUtil().setHeight(400),
          ),
          painter: GetLoginBlueGray(),
        )
    );
  }

  //TODO: rightCircle
  Widget rightImage({@required size}) {
    return Positioned(
      top: -size.height * 0.3,
      left: size.width / 1.8,
      child: Container(
        height: size.width,
        width: size.width,
        decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.15),
            borderRadius: BorderRadius.circular(size.width)
        ),
      ),
    );
  }

  Widget rightBottomImage({@required size}) {
    return Positioned(
      bottom: -size.height * 0.3,
      left: size.width / 1.8,
      child: Container(
        height: size.width,
        width: size.width,
        decoration: BoxDecoration(
            color: Colors.grey[850].withOpacity(0.15),
            borderRadius: BorderRadius.circular(size.width)
        ),
      ),
    );
  }

//TODO: leftCircle
  Widget leftImage({@required size}) {
    return Positioned(
      top: size.height - size.width,
      right: size.width / 1.8,
      child: Container(
        height: size.width,
        width: size.width,
        decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.15),
            borderRadius: BorderRadius.circular(size.width)
        ),
      ),
    );
  }

//TODO: top image painter
  Widget topImagePainter() {
    return Positioned(
        child: CustomPaint(
          child: Container(
            decoration: BoxDecoration(
            ),
            height: ScreenUtil().setHeight(400),
          ),
          painter: GetLoginBlueGray(),
        )
    );
  }

//TODO: logo
  Widget logo() {
    return Positioned(
      top: ScreenUtil().setHeight(50),
      left: ScreenUtil().setHeight(10),
      child: CircleAvatar(
        radius: 90,
        backgroundColor: Colors.transparent,
        child: ImageIcon(AssetImage('images/logonotificacion.png'),
          size: ScreenUtil().setHeight(180), color: Colors.white,),
      ),
    );
  }

//TODO: title
  Widget title() {
    return InkWell(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 30,),
          child: Text(
            _isRegister ? 'Registrarme' : 'Iniciar Sesión',
            style: TextStyle(
                color: Colors.grey[900].withOpacity(0.9),
                fontSize: ScreenUtil().setSp(50),
                fontWeight: FontWeight.w700,
                wordSpacing: 2,
                letterSpacing: -1
            ),
          ),
        ),
      ),
    );
  }

//TODO: register text fields
  void showValidateAlert({text, key, height, width}) {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: text,
        textStyle: TextStyle(color: Colors.white),
        height: height,
        width: width,
        backgroundColor: Colors.black.withOpacity(0.5),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        borderRadius: BorderRadius.circular(10.0)
    );
    popup.show(widgetKey: key);
  }

//TODO: register text fields
  Widget signUp(){
    var key = GlobalKey();
    var key2 = GlobalKey();
    var key3 = GlobalKey();
    var key4 = GlobalKey();
    var key5 = GlobalKey();
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            textFieldContainer(title: 'Nombre(s)',child: TextFormField(
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400]
                  ),
                  icon: Icon(Icons.person_pin),
                  hintText: 'Ingrese su(s) nombre(s)',
                  border: InputBorder.none,
                  suffixIcon: !_validateName ?InkWell(
                    key: key,
                    onTap: (){
                      showValidateAlert(key: key, text: 'Debe llenar este campo', height: 50.0,width: 190.0);
                    },
                    child: Icon(Icons.error_outline, color: Colors.red),
                  ) : Icon(Icons.check, color: Colors.green,),
                ),
                validator: (input){
                  if(input.isEmpty){
                    setState(() {
                      _validateName = false;
                    });
                    return null;
                  }else if(input == ''){
                    setState(() {
                      _validateName = false;
                    });
                    return null;
                  }
                  setState(() {
                    _validateName = true;
                  });
                  return null;
                },
                controller:  _nameController,
                focusNode: _nameNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value){
                  _fieldFocusChange(context, _nameNode, _lastNameNode);
                },
                onChanged: (value){
                  if(value.length >=0){
                    var _res =_formKey.currentState.validate();
                  }
                },
                inputFormatters: [new LengthLimitingTextInputFormatter(15)]
            ),currentLength: _nameController.text.length,maxLength: 15
            ),
            textFieldContainer(title: 'Apellido(s)', child: TextFormField(
              inputFormatters: [new LengthLimitingTextInputFormatter(20)],
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400]
                ),
                icon: Icon(Icons.person_pin),
                hintText: 'Ingrese su(s) apellido(s)',
                border: InputBorder.none,
                suffixIcon: !_validateLastName ?InkWell(
                  key: key2,
                  onTap: (){
                    showValidateAlert(key: key2, text: 'Debe llenar este campo', height: 50.0,width: 190.0);
                  },
                  child: Icon(Icons.error_outline, color: Colors.red),
                ) : Icon(Icons.check, color: Colors.green,),
              ),
              validator: (input){
                if(input.isEmpty){
                  setState(() {
                    _validateLastName = false;
                  });
                  return null;
                }else if(input == ''){
                  setState(() {
                    _validateLastName = false;
                  });
                  return null;
                }
                setState(() {
                  _validateLastName = true;
                });
                return null;
              },
              controller:  _lastNameController,
              focusNode: _lastNameNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value){
                _fieldFocusChange(context, _lastNameNode, _emailNode);
              },
              onChanged: (value){
                if(value.length >=0){
                  var _res =_formKey.currentState.validate();
                }
              },
            ),currentLength: _lastNameController.text.length, maxLength: 20
            ),
            textFieldContainer(title: 'Correo', child: TextFormField(
              inputFormatters: [new LengthLimitingTextInputFormatter(80)],
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400]
                ),
                icon: Icon(Icons.email),
                hintText: 'Ingrese su correo',
                border: InputBorder.none,
                suffixIcon: !_validateEmail ?InkWell(
                  key: key3,
                  onTap: (){
                    showValidateAlert(key: key3, text: 'El correo no es valido', height: 50.0,width: 190.0);
                  },
                  child: Icon(Icons.error_outline, color: Colors.red),
                ) : Icon(Icons.check, color: Colors.green,),
              ),
              validator: validateEmail,
              controller: _emailController,
              focusNode: _emailNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value){
                _fieldFocusChange(context, _emailNode, _passNode);
              },
              onChanged: (value){
                if(value.length >=0){
                  var _res =_formKey.currentState.validate();
                }
              },
            ),maxLength: 80, currentLength: _emailController.text.length
            ),
            textFieldContainer(title: 'Contraseña', child: TextFormField(
              inputFormatters: [new LengthLimitingTextInputFormatter(40)],
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400]
                  ),
                  icon: Icon(Icons.lock),
                  hintText: 'Ingrese una contraseña',
                  border: InputBorder.none,
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          onTap: (){
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          child: Icon(Icons.remove_red_eye, color: _isObscure ? Colors.grey : Colors.red,),
                        ),
                        SizedBox(width: 10,),
                        !_validatePass ?InkWell(
                          key: key4,
                          onTap: (){
                            showValidateAlert(key: key4, text: message4 != '' ? message4 : 'Debe llenar este campo.', height: 80.0,width: 190.0);
                          },
                          child: Icon(Icons.error_outline, color: Colors.red),
                        ) : Icon(Icons.check, color: Colors.green,),
                      ],
                    ),
                  )
              ),
              validator: (input){
                if(input.isEmpty){
                  setState(() {
                    message4 = 'Debe llenar este campo.';
                    _validatePass = false;
                  });
                  return null;
                }else if(input == ''){
                  setState(() {
                    message4 = 'Debe llenar este campo.';
                    _validatePass = false;
                  });
                  return null;
                }else if(input.length <8){
                  setState(() {
                    message4 = 'La contraseña debe tener minimo 8 caracteres.';
                    _validatePass = false;
                  });
                  return null;
                }
                setState(() {
                  _validatePass = true;
                });
                return null;
              },
              controller:  _passController,
              focusNode: _passNode,
              obscureText: _isObscure,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value){
                _fieldFocusChange(context, _passNode, _pass2Node);
              },
              onChanged: (value){
                if(value.length >=0){
                  var _res =_formKey.currentState.validate();
                }
              },
            ),currentLength: _passController.text.length, maxLength: 40
            ),
            textFieldContainer(title: 'Confirme la contraseña', child: TextFormField(
              inputFormatters: [new LengthLimitingTextInputFormatter(40)],
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400]
                  ),
                  icon: Icon(Icons.lock),
                  hintText: 'Ingrese una contraseña',
                  border: InputBorder.none,
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          onTap: (){
                            setState(() {
                              _isObscure2 = !_isObscure2;
                            });
                          },
                          child: Icon(Icons.remove_red_eye, color: _isObscure2 ? Colors.grey : Colors.red,),
                        ),
                        SizedBox(width: 10,),
                        !_validatePass2 ?InkWell(
                          key: key5,
                          onTap: (){
                            showValidateAlert(key: key5, text: message5 != '' ? message5 : 'Debe llenar este campo.', height: 80.0,width: 190.0);
                          },
                          child: Icon(Icons.error_outline, color: Colors.red),
                        ) : Icon(Icons.check, color: Colors.green,),
                      ],
                    ),
                  )
              ),
              validator: (input){
                if(input.isEmpty){
                  setState(() {
                    message5 ='Debe llenar este campo.';
                    _validatePass2 = false;
                  });
                  return null;
                }else if(input == ''){
                  setState(() {
                    message5 ='Debe llenar este campo.';
                    _validatePass2 = false;
                  });
                  return null;
                }else if(input.length <8){
                  setState(() {
                    message5 = 'La contraseña debe tener minimo 8 caracteres.';
                    _validatePass2 = false;
                  });
                  return null;
                }else if(_passController.text != _pass2Controller.text){
                  setState(() {
                    message5 = 'Las contraseñas no coinciden.';
                    _validatePass2 = false;
                  });
                  return null;
                }
                setState(() {
                  _validatePass2 = true;
                });
                return null;
              },
              controller:  _pass2Controller,
              obscureText: _isObscure2,
              focusNode: _pass2Node,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value){
                _pass2Node.unfocus();
              },
              onChanged: (value){
                if(value.length >=0){
                  var _res =_formKey.currentState.validate();
                }
              },
            ),maxLength: 40, currentLength: _pass2Controller.text.length
            ),
          ],
        ),
      ),
    );
  }
  //TODO: login text fields
  Widget signIn(){
    var key1 = GlobalKey();
    var key2 = GlobalKey();
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            textFieldContainer(title: 'Correo', child: TextFormField(
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Ingrese su correo',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400]
                  ),
                  border: InputBorder.none,
                  suffixIcon: !_validateEmail ?InkWell(
                    key: key1,
                    onTap: (){
                      showValidateAlert(key: key1, text: 'El correo no es valido', height: 50.0,width: 190.0);
                    },
                    child: Icon(Icons.error_outline, color: Colors.red),
                  ) : Icon(Icons.check, color: Colors.green,),
                ),
                validator: validateEmail,
                controller: _emailController,
                focusNode: _emailNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value){
                  _fieldFocusChange(context, _emailNode, _passNode);
                },
                onChanged: (value){
                  if(value.length >=0){
                    var _res =_formKey.currentState.validate();
                  }
                },
                inputFormatters: [new LengthLimitingTextInputFormatter(80)]
            ),currentLength: _emailController.text.length,
                maxLength: 80
            ),
            textFieldContainer(title: 'Contraseña', child: TextFormField(
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[400]
                    ),
                    icon: Icon(Icons.lock),
                    hintText: 'Ingrese su contraseña',
                    border: InputBorder.none,
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                            onTap: (){
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            child: Icon(Icons.remove_red_eye, color: _isObscure ? Colors.grey : Colors.red,),
                          ),
                          SizedBox(width: 10,),
                          !_validatePass ?InkWell(
                            key: key2,
                            onTap: (){
                              showValidateAlert(key: key2, text: message4 != '' ? message4 : 'Debe llenar este campo.', height: 80.0,width: 190.0);
                            },
                            child: Icon(Icons.error_outline, color: Colors.red),
                          ) : Icon(Icons.check, color: Colors.green,),
                        ],
                      ),
                    )
                ),
                validator: (input){
                  if(input.isEmpty){
                    setState(() {
                      message4 = 'Debe llenar este campo.';
                      _validatePass = false;
                    });
                    return null;
                  }else if(input == ''){
                    setState(() {
                      message4 = 'Debe llenar este campo.';
                      _validatePass = false;
                    });
                    return null;
                  }else if(input.length <8){
                    setState(() {
                      message4 = 'La contraseña debe tener minimo 8 caracteres.';
                      _validatePass = false;
                    });
                    return null;
                  }
                  setState(() {
                    _validatePass = true;
                  });
                  return null;
                },
                controller:  _passController,
                focusNode: _passNode,
                obscureText: _isObscure,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value){
                  _fieldFocusChange(context, _passNode, _pass2Node);
                },
                onChanged: (value){
                  if(value.length >=0){
                    var _res =_formKey.currentState.validate();
                  }
                },
                inputFormatters: [new LengthLimitingTextInputFormatter(40)]
            ),maxLength: 40,currentLength: _passController.text.length
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: (){

              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Olvidé mi contraseña',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
//TODO: social login / signIn button
  Widget loginButtons({@required authService, @required size}) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              width: size.width / 2,
              child: !_isRegister ? Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buttomStyle(
                    name: 'Google',
                    color: Colors.deepOrange,
                    imageRoute: 'google.png',
                    imageColor: null,
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      dynamic result = await authService.signInWithGoogle();
                      setState(() {
                        _loading = true;
                      });
                      if (result != null) {
                        print('LoggedIn');
                        setState(() {
                          _loading = false;
                        });
                      } else {
                        setState(() {
                          _loading = false;
                        });
                        Widgets().snackBar(
                            scaffoldGlobalKey: scaffoldGlobalKey,
                            color: Colors.black.withOpacity(0.8),
                            textColor: Colors.white.withOpacity(0.8),
                            message: 'Error al iniciar con Google.'
                        );
                        print('Error signing in');
                      }
                    },
                  ),
                  SizedBox(width: 10,),
                  buttomStyle(
                    name: 'Facebook',
                    color: Colors.blue,
                    imageRoute: 'facebook.png',
                    imageColor: Colors.blue[800],
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      dynamic result = await AuthService().signInWithFacebook();
                      if (result != null) {
                        print('LoggedIn');
                        setState(() {
                          _loading = false;
                        });
                      } else {
                        setState(() {
                          _loading = false;
                        });
                        Widgets().snackBar(
                            scaffoldGlobalKey: scaffoldGlobalKey,
                            color: Colors.black.withOpacity(0.8),
                            textColor: Colors.white.withOpacity(0.8),
                            message: 'Error al iniciar con Facebook.'
                        );
                        print('Error signing in');
                      }
                    },
                  ),
                  SizedBox(width: 10,),

                ],
              ) : Container(width: size.width / 2,),
            ),
            Container(
              padding: EdgeInsets.only(right: 16),
              alignment: Alignment.centerRight,
              width: size.width / 2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Ingresar',
                    style: TextStyle(
                        color: Colors.grey[900].withOpacity(0.85),
                        fontSize: 16,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  SizedBox(width: 10,),
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    heroTag: null,
                    key: GlobalKey(debugLabel: 'login'),
                    child: Icon(
                      Icons.arrow_forward,color: Colors.white,
                    ),
                    onPressed: () async{
                      if(_isRegister){
                        createUserWithEmail();
                      }else{
                        logInWithemail();
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Future createUserWithEmail() async{
    if(_validatePass && _validatePass2 && _validateName && _validateLastName && _validateEmail && (_pass2Controller.text == _passController.text)){
      setState(() {
        _loading = true;
      });
      var name = '${_nameController.text} ${_lastNameController.text}';
      dynamic result = await AuthService().signUpWithEmail(context: context, email: _emailController.text, password: _pass2Controller.text, name: name);
      if (result != null) {
        setState(() {
          _emailController.text = '';
          _passController.text = '';
          _pass2Controller.text = '';
          _nameController.text = '';
          _lastNameController.text = '';
          name = '';
        });
        print('LoggedIn');
        setState(() {
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
        Widgets().snackBar(
            scaffoldGlobalKey: scaffoldGlobalKey,
            color: Colors.black.withOpacity(0.8),
            textColor: Colors.white.withOpacity(0.8),
            message: 'Error al crear la cuenta.'
        );
        print('Error signing in');
      }
    }else{
      Widgets().snackBar(
          scaffoldGlobalKey: scaffoldGlobalKey,
          message: 'Debe llenar todos los campos.',
          textColor: Colors.white.withOpacity(0.8),
          color: Colors.black.withOpacity(0.8)
      );
    }
  }
  Future logInWithemail() async{
    if(_validatePass && _validateEmail){
      setState(() {
        _loading = true;
      });
      dynamic result = await AuthService().loginWithEmail(email: _emailController.text, password: _passController.text, context: context);
      if (result != null) {
        setState(() {
          _emailController.text = '';
          _passController.text = '';
          _pass2Controller.text = '';
          _nameController.text = '';
          _lastNameController.text = '';
        });
        print('LoggedIn');
        setState(() {
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
        Widgets().snackBar(
            scaffoldGlobalKey: scaffoldGlobalKey,
            color: Colors.black.withOpacity(0.8),
            textColor: Colors.white.withOpacity(0.8),
            message: 'Error al inicias sesión.'
        );
        print('Error signing in');
      }
    }else{
      Widgets().snackBar(
          scaffoldGlobalKey: scaffoldGlobalKey,
          message: 'Debe llenar todos los campos.',
          textColor: Colors.white.withOpacity(0.8),
          color: Colors.black.withOpacity(0.8)
      );
    }
  }

//TODO: register button
  Widget registerButton() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          children: [
            TextSpan(
              text: _isRegister
                  ? '¿Ya tienes una cuenta? \n'
                  : '¿Aún no tienes una cuenta? \n',
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13,
                  fontWeight: FontWeight.w500
              ),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    _emailController.text = '';
                    _passController.text = '';
                    _pass2Controller.text = '';
                    _nameController.text = '';
                    _lastNameController.text = '';
                    if (_isRegister) {
                      _isRegister = false;
                    } else {
                      _isRegister = true;
                    }
                  });
                },
              text: _isRegister ? 'Iniciar Sesión' : 'Registrate Aquí',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            )
          ]
      ),
    );
  }

  Widget textFieldContainer({@required child, title, maxLength, currentLength}){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 5, top: 5,left: 5),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
        Container(
            height: 60,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 15, right: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300], width: 2.5)
            ),
            child: child
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2,horizontal: 8),
            child: Text(
              '$currentLength / $maxLength',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buttomStyle({@required name, imageRoute, color, onPressed, imageColor, backgroundColor, splashColor}) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 2,
                spreadRadius: 1,
                offset: Offset(0, 1)
            )
          ]
      ),
      child: FloatingActionButton(
          heroTag: null,
          key: GlobalKey(debugLabel: '$name'),
          backgroundColor: Colors.white,
          focusColor: Colors.transparent,
          mini: true,
          elevation: 0,
          splashColor: color,
          onPressed: onPressed,
          child: Image.asset(
            'images/$imageRoute', height: 40, color: imageColor,),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
      ),
    );
  }
}