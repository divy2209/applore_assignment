import 'package:applore_assignment/src/model/user.dart';
import 'package:applore_assignment/src/services/config.dart';
import 'package:applore_assignment/src/services/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authorization {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserID? _user(User? user){
    return user != null ? UserID(uid: user.uid) : null;
  }

  Stream<UserID?> get user {
    return _auth.authStateChanges().map((_user));
  }
  Future login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      Local.sharedPreferences.setString(Local.uid, user!.uid);
      //Local.sharedPreferences.setString(Local.name, name!);
      return _user(user);
    } catch(e) {
      print(e.toString() + e.hashCode.toString());
      return;
    }
  }
  
  Future register(String email, String password, String? name) async {
    try {
      if(name!=null) return;
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      UserData(uid: user!.uid).addUser(name: name);
      Local.sharedPreferences.setString(Local.uid, user.uid);
      //Local.sharedPreferences.setString(Local.name, name!);
      return _user(user);
    } catch(e) {
      print(e.toString());
      return;
    }
  }

  Future logout() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      return;
    }
  }
}