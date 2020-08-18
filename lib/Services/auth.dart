import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ragapp/Services/FirestoreService.dart';
import 'package:ragapp/models/userModel.dart';

class AuthService{
  //TODO: instances:
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirestoreService _fireStoreService = FirestoreService();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final facebookLogin = FacebookLogin();

  var _user;
  //TODO: create user object based on FirebaseUser
  User _userFromFirebaseUSer(FirebaseUser user){

    return user != null ? User(uid: user.uid) : null;
  }

  //TODO: auth user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
    .map(_userFromFirebaseUSer);
  }
  //TODO: sign google
  Future signInWithGoogle() async{
    //TODO: get device token
    var token;
    _firebaseMessaging.getToken().then((_token) => token = _token);
    try{
      final GoogleSignInAccount _googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication _googleSignInAuthentication = await _googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: _googleSignInAuthentication.idToken,
          accessToken: _googleSignInAuthentication.accessToken
      );
      FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      if(user != null){
        _user = user.uid;
        await _fireStoreService.createUser(User(
          uid: user.uid,
          phone: user.phoneNumber,
          email: user.email,
          name: user.displayName,
          isOnline: true,
          birthDay: null,
          deviceToken: token,
          firstJoin: DateTime.now().toString(),
          status: '',
          address: null,
          isAdmin: false,
          ministerios: [],
          lastJoin: DateTime.now().toString(),
          photoUrl: user.photoUrl,
          searchIndex: await _fireStoreService.userSearchIndex(user.displayName)
        ));
        return _userFromFirebaseUSer(user);
      }else{
        return null;
      }
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //TODO: sign in
  Future loginWithEmail({@required String email, @required String password, @required context}) async{
    try{
      FirebaseUser user = (await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      )).user;
      if(user == null){
        print("error signInWithEmail");
        return null;
      }
      else{
        return _userFromFirebaseUSer(user);
      }
    }catch(e){
      print(e);
      return null;
    }
  }

  //TODO: sign up email
  Future signUpWithEmail({
    @required context,
    @required String email,
    @required String password,
    @required String name,
    //fotoURL
  }) async{
    //TODO: get device token
    var token;
    _firebaseMessaging.getToken().then((_token) => token = _token);
    try{
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      // create a new user profile on firestore
      await _fireStoreService.createUser(User(
          uid: authResult.user.uid,
          phone: null,
          email: email,
          name: name,
          isOnline: true,
          birthDay: null,
          deviceToken: token,
          firstJoin: DateTime.now().toString(),
          status: '',
          address: null,
          isAdmin: false,
          ministerios: [],
          lastJoin: DateTime.now().toString(),
          photoUrl: 'https://firebasestorage.googleapis.com/v0/b/red-de-alcance-global.appspot.com/o/utils%2FnewUserPhoto.png?alt=media&token=f34e3ece-186e-4e02-9a3b-79361e4f29fb',
          searchIndex: await _fireStoreService.userSearchIndex(name)
      ));
      print('email = ${authResult.user.email}');
      return _userFromFirebaseUSer(authResult.user);
    }catch(e){
      print(e);
      return null;
    }
  }

  //TODO: sign facebook
  Future signInWithFacebook()async{
    try {
      var token = await _firebaseMessaging.getToken();
      print('device token == $token');
      final result = await facebookLogin.logIn(['email']);
      if(result.status != FacebookLoginStatus.loggedIn){
        print('respuesta de estado ${result.errorMessage}');
        return null;
      }
      else{
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token
        );
        final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

        if(user != null){
          _user = user.uid;
          await _fireStoreService.createUser(User(
              uid: user.uid,
              phone: user.phoneNumber,
              email: user.email,
              name: user.displayName,
              isOnline: true,
              birthDay: null,
              deviceToken: token,
              firstJoin: DateTime.now().toString(),
              status: '',
              address: null,
              isAdmin: false,
              ministerios: [],
              lastJoin: DateTime.now().toString(),
              photoUrl: user.photoUrl,
              searchIndex: await _fireStoreService.userSearchIndex(user.displayName)
          ));
          return _userFromFirebaseUSer(user);
        }else{
          return null;
        }
      }
    }catch (e) {
      print(e.message);
      return false;
    }
  }


  //TODO: sign out
Future signOut({user}) async{
    try{
      return await _fireStoreService.updateUserStatus(user: user,isOnline: false, lastJoin: DateTime.now().toString()).then((value) => print('bien')).catchError((error) => print('mal')).then((value) async{
        await  _auth.signOut();
        await _googleSignIn.signOut();
        await _googleSignIn.disconnect();
        await facebookLogin.logOut();
      });
    }catch(e){
      print(e.toString());
      return null;
    }
}
}


