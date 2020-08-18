import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/models/userModel.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  LifeCycleManager({Key key, this.child}) : super(key: key);
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}
class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  //TODO: objects
  FirestoreService _firestoreService = FirestoreService();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    //TODO: listen user's id
    final user = Provider.of<User>(context, listen: false);
    if(state == AppLifecycleState.paused || state == AppLifecycleState.inactive){
      //TODO: set user offline connection
      await _firestoreService.updateUserStatus(user: user, isOnline: false, lastJoin: DateTime.now().toString());
      await _firestoreService.closeAllStreams();
    }else if(state == AppLifecycleState.resumed){
      //TODO: set user online connection
      await _firestoreService.updateUserStatus(user: user, isOnline: true, lastJoin: DateTime.now().toString());
    }else{
      print('unknow state = $state');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }

}