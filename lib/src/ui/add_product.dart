import 'dart:io';

import 'package:applore_assignment/src/model/user.dart';
import 'package:applore_assignment/src/services/product_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _description = TextEditingController();

  File? imageFile = null;
  late double originalSize;
  late double compressedSize;

  void clear(){
    imageFile = null;
    _name.clear();
    _price.clear();
    _description.clear();
  }

  @override
  Widget build(BuildContext context) {
    final String uid = Provider.of<UserID?>(context)!.uid;
    void unfocus(){
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        currentFocus.focusedChild!.unfocus();
      }
    }
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: unfocus,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade800,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40,),
              Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: size.width*0.14,
                      backgroundColor: Colors.grey[400]!.withOpacity(0.4),
                      backgroundImage: imageFile==null ? null : FileImage(imageFile!),
                      child: imageFile==null ? Icon(
                        Icons.person,
                        color: Colors.white,
                        size: size.width*0.1,
                      ) : null,
                    ),
                  ),
                  Positioned(
                    top: size.height*0.08,
                    left: size.width*0.56,
                    child: Container(
                        height: size.width*0.1,
                        width: size.width*0.1,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2)
                        ),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                            if(pickedFile!=null){
                              imageFile = File(pickedFile.path);
                              double kb = imageFile!.readAsBytesSync().lengthInBytes/1024;
                              originalSize = (((kb/1024)*100).round())/100;
                              final filePath = imageFile!.absolute.path;
                              final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
                              final splitted = filePath.substring(0, (lastIndex));
                              final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

                              final compressedImage = await FlutterImageCompress.compressAndGetFile(
                                  filePath,
                                  outPath,
                                  quality: 50
                              );
                              imageFile = File(compressedImage!.path);
                              kb = imageFile!.readAsBytesSync().lengthInBytes/1024;
                              compressedSize = (((kb/1024)*100).round())/100;
                              setState(() {
                                
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Container(
                                    height: 50,
                                    child: Column(
                                      children: [
                                        Text("Original Image Size: " + originalSize.toString() + "MB", style: const TextStyle(color: Colors.black),),
                                        Text("Compressed Image Size: " + compressedSize.toString() + "MB", style: const TextStyle(color: Colors.black))
                                      ],
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                  duration: const Duration(seconds: 5),
                                )
                              );
                            }
                          },
                          child: const Icon(Icons.add, color: Colors.blue,),
                        )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: size.width*0.64,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Name",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
                      ),
                      controller: _name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Price",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
                      ),
                      controller: _price,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 40,),
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)
                      ),
                      child: TextFormField(
                        maxLines: null,
                        decoration: const InputDecoration(
                            hintText: "Description",
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none
                        ),
                        controller: _description,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60,),
              ElevatedButton(
                onPressed: () async {
                  unfocus();
                  if(imageFile!=null && _name.text.isNotEmpty && _price.text.isNotEmpty && _description.text.isNotEmpty){
                    String url = await ProductData().upload(imageFile);
                    if(url!=null){
                      dynamic result = await ProductData(uid: uid).addProduct(name: _name.text, price: _price.text, url: url, description: _description.text);
                      clear();
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text("Add Product"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
