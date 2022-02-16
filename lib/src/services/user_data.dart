import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  UserData({required this.uid});

  final CollectionReference profile = FirebaseFirestore.instance.collection('profiles');

  Future addUser({required String? name}) async {
    return await profile.doc(uid).set({
      //'uid' : uid,
      'name' : name
    });
  }

  Future<String> getUser() async {
    if(true){
      profile.doc(uid).get().then((snap) {
        return snap.get('name');
      });
    }
    return "";
  }
}