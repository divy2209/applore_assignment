import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductData {
  final String? uid;
  ProductData({this.uid});
  final CollectionReference product = FirebaseFirestore.instance.collection('products');

  Future addProduct({required String name, required String price, required String url, required String description}) async {
    return await product.doc().set({
      'uid' : uid,
      'name' : name,
      'prince' : price,
      'url' : url,
      'description' : description
    });
  }

  Future<String> upload(imageFile) async {
    String filename = DateTime.now().microsecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(filename);
    await reference.putFile(imageFile);
    String url = await reference.getDownloadURL();
    return url;
  }



}