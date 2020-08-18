import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/models/MinisterioModel.dart';
import 'package:ragapp/utils/Widgets/CustomDialog.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';

class CUMinisterio extends StatefulWidget {
  final editing;
  final name;
  final leaderList;
  final desc;
  final url;
  final docId;
  CUMinisterio({this.editing,this.name, this.leaderList, this.url, this.desc, this.docId});
  @override
  _CUMinisterioState createState() => _CUMinisterioState();
}

class _CUMinisterioState extends State<CUMinisterio> {
  //TODO: Global keys
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //TODO: instances
  Widgets _widgets = Widgets();
  CollectionReference _db = Firestore.instance.collection('ministerio');
  Ministerio _ministerio;
  //TODO: variables
  bool _loading = false;
  bool _editing = false;
  String _url;
  String _id;
  String _desc;
  bool _validateUrl = false;
  bool _validateName = false;
  List<String> _usersID = [];
  List _selectedUsers = [];
  //TODO: controllers
  var _nameController = TextEditingController();
  var _urlController = TextEditingController();
  var _descController = TextEditingController();
  //TODO: onbackPressed
  Future<bool> response(){
    return _widgets.onBackPressedWithRoute(
        dismissible: true,
        context: context,
        title: !widget.editing ? 'Cancelar Creación' : 'Cancelar Moficación',
        fontSize: 13,
        message: !widget.editing ?'Está seguro? No se creará ningún ministerio.' : 'Está seguro? No se aplicará ningún cambio.',
        singOut: false,
        route: null
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.editing){
      _urlController.text = widget.url;
      _nameController.text = widget.name;
      _descController.text = widget.desc;
      _selectedUsers = (widget.leaderList);
      print(_selectedUsers.toString());
      Future.delayed(Duration(milliseconds: 500)).then((value) => _formKey.currentState.validate());
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
      message: widget.editing ? 'Modificando ministerio' : 'Creando ministerio.',
      messageTextStyle: TextStyle(
      ),
    );
    //TODO: provider
    final users = Provider.of<List>(context);

    void _onSelectedUser(bool selected, uid){
      if(selected){
        setState(() {
          _selectedUsers.add(uid);
        });
        print(_selectedUsers.toString());
      }else{
        setState(() {
          _selectedUsers.remove(uid);
        });
        print(_selectedUsers.toString());
      }
    }

    return WillPopScope(
      onWillPop: response,
      child: Scaffold(
        key: scaffoldGlobalKey,
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          titleSpacing: 0,
          title: Text(
            !widget.editing ? 'Crear Ministerio' : 'Modificar Ministerio',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: //Colors.black
                Colors.white
            ),
          ),
          leading: InkWell(
              onTap: () async{
                var res = await response();
                if(res){
                  Navigator.of(context).pop();
                }
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
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          spreadRadius: 0.1,
                          blurRadius: 0.1,
                          offset: Offset(0, 1)
                        )
                      ]
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: TextFormField(
                        onTap: (){

                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(!_validateUrl ? Icons.error_outline : Icons.check, color: !_validateUrl ? Colors.red : Colors.green,),
                          icon: ImageIcon(
                            _url != null && _url != '' ? NetworkImage(_url) : NetworkImage('https://image.flaticon.com/icons/png/512/149/149919.png',),
                            color: Colors.grey[800],
                          ),
                          hintText: 'Url del icono',
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (value){

                        },
                        validator: (input){
                          if(input.isEmpty){
                            setState(() {
                              _validateUrl = false;
                            });
                            return 'llene el campo';
                          }else if(input == ''){
                            setState(() {
                              _validateUrl = false;
                            });
                            return 'llene el campo';
                          }
                          setState(() {
                            _validateUrl = true;
                          });
                          return null;
                        },
                        controller:  _urlController,
                        onChanged: (value){
                          setState(() {
                            _url = _urlController.text;
                          });
                          if(value.length >=0){
                            _formKey.currentState.validate();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[500],
                              spreadRadius: 0.1,
                              blurRadius: 0.1,
                              offset: Offset(0, 1)
                          )
                        ]
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: TextFormField(
                        onTap: (){

                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.text_fields),
                          hintText: 'Nombre del ministerio',
                          border: InputBorder.none,
                          suffixIcon: Icon(!_validateName ? Icons.error_outline : Icons.check, color: !_validateName ? Colors.red : Colors.green,),
                        ),
                        onFieldSubmitted: (value){

                        },
                        validator: (input){
                          if(input.isEmpty){
                            setState(() {
                              _validateName = false;
                            });
                            return 'llene el campo';
                          }else if(input == ''){
                            setState(() {
                              _validateName = false;
                            });
                            return 'llene el campo';
                          }
                          setState(() {
                            _validateName = true;
                          });
                          return null;
                        },
                        controller:  _nameController,
                        onChanged: (value){
                          if(value.length >=0){
                            var _res =_formKey.currentState.validate();

                          }

                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[500],
                              spreadRadius: 0.1,
                              blurRadius: 0.1,
                              offset: Offset(0, 1)
                          )
                        ]
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: TextFormField(
                        onTap: (){

                        },
                        maxLength: 170,
                        maxLines:  null,
                        decoration: InputDecoration(
                          icon: Icon(Icons.description),
                          hintText: 'Descripción del ministerio',
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (value){

                        },
                        controller:  _descController,
                        onChanged: (value){
                          if(value.length >=0){
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                      child: Text(
                        'Agregar lider (Opcional)',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[600],
                            fontSize: 10
                        ),
                      ),
                    )
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: users.length * 70.1,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CheckboxListTile(
                            value: _selectedUsers.contains(users[index].uid),
                            onChanged: (selected){
                              _onSelectedUser(selected, users[index].uid);
                            },
                            secondary:  Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[500],
                                            blurRadius: 0.1,
                                            spreadRadius: 0.1,
                                            offset: Offset(0, 1)
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(90),
                                      image: DecorationImage(
                                          image: NetworkImage(users[index].photoUrl),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  users[index].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[900]
                                  ),
                                )
                              ],
                            ),
                          )
                        );
                      },
                    ),
                  )
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Visibility(
          visible: _formKey.currentState != null ? _formKey.currentState.validate() : false,
          child: FloatingActionButton(
            onPressed: () async{
              if(widget.editing){
                setState(() {
                });
                var res = await updateMinisterio(pr: pr);
                if(res){
                  await pr.hide();
                  _widgets.snackBar(
                      scaffoldGlobalKey: scaffoldGlobalKey,
                      color: Colors.black.withOpacity(0.8),
                      textColor: Colors.white.withOpacity(0.8),
                      message: 'Ministerio modificado exitosamente.'
                  );
                  Future.delayed(Duration(milliseconds: 800)).then((value) => Navigator.of(context).pop());
                }else{
                  await pr.hide();
                  _widgets.snackBar(
                      scaffoldGlobalKey: scaffoldGlobalKey,
                      color: Colors.black.withOpacity(0.8),
                      textColor: Colors.white.withOpacity(0.8),
                      message: 'Error al modificar el ministerio.'
                  );
                }
              }else{
                var res = await createMinisterio(pr: pr);
                if(res){
                  await pr.hide();
                  _widgets.snackBar(
                      scaffoldGlobalKey: scaffoldGlobalKey,
                      color: Colors.black.withOpacity(0.8),
                      textColor: Colors.white.withOpacity(0.8),
                      message: 'Ministerio creado exitosamente.'
                  );
                  Future.delayed(Duration(milliseconds: 800)).then((value) => Navigator.of(context).pop());
                }else{
                  await pr.hide();
                  _widgets.snackBar(
                      scaffoldGlobalKey: scaffoldGlobalKey,
                      color: Colors.black.withOpacity(0.8),
                      textColor: Colors.white.withOpacity(0.8),
                      message: 'Error al crear el ministerio.'
                  );
                }
              }
            },
            child: Icon(Icons.cloud_done),
          ),
        ),
      ),
    );
  }

  Future<bool> createMinisterio({pr}) async{
    var _docID = _db.document().documentID;
    if(_formKey.currentState.validate()){
      await pr.show();
      _ministerio = Ministerio(
        leaderList: _selectedUsers,
        creationDate: DateTime.now().toString(),
        name: _nameController.text,
        id: _docID,
        description: _descController.text != null ? _descController.text : '',
        imageUrl: _urlController.text,
      );
      return await Future.delayed(Duration(milliseconds: 3200)).then((value) => FirestoreService().createMinisterio(_ministerio));
    }
  }
  Future<bool> updateMinisterio({pr}) async{
    if(_formKey.currentState.validate()){
      await pr.show();
      _ministerio = Ministerio(
        leaderList: _selectedUsers,
        creationDate: DateTime.now().toString(),
        name: _nameController.text,
        id: widget.docId,
        description: _descController.text != null ? _descController.text : '',
        imageUrl: _urlController.text,
      );
      return await Future.delayed(Duration(milliseconds: 3200)).then((value) => FirestoreService().createMinisterio(_ministerio));
    }
  }
}
