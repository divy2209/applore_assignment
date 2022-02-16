import 'package:applore_assignment/src/services/authentication.dart';
import 'package:applore_assignment/src/services/config.dart';
import 'package:applore_assignment/src/services/product_data.dart';
import 'package:applore_assignment/src/ui/add_product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<DocumentSnapshot> _products = [];
  bool loading = true;
  late DocumentSnapshot _lastDocument;
  final ScrollController _controller = ScrollController();
  bool gettingMore = false;
  bool moreAvailable = true;

  Future<void> _getProducts() async {
    Query q = ProductData().product.where('uid', isEqualTo: Local.sharedPreferences.getString(Local.uid)).orderBy('name').limit(10);
    setState(() {
      loading = true;
    });
    QuerySnapshot snap = await q.get();
    _products = snap.docs;
    _lastDocument = snap.docs[snap.docs.length-1];
    setState(() {
      loading = false;
    });
  }

  _getMoreProducts() async {
    if(gettingMore){
      return;
    }
    gettingMore = true;
    Query q = ProductData().product.where('uid', isEqualTo: Local.sharedPreferences.getString(Local.uid)).orderBy('name').startAfter([_lastDocument.get('name')]).limit(10);
    QuerySnapshot snap = await q.get();
    if(snap.docs.length<10){
      moreAvailable = false;
    }
    _products.addAll(snap.docs);
    _lastDocument = snap.docs[snap.docs.length-1];
    setState(() {
      gettingMore = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProducts();
    _controller.addListener(() {
      double maxScroll = _controller.position.maxScrollExtent;
      double currentScroll = _controller.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if(maxScroll-currentScroll <= delta && moreAvailable){
        _getMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: AppBar(
        title: const Text("Hello"),
        leading: IconButton(
          onPressed: (){
            Authorization().logout();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> const AddProduct())
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 20),
        child: loading ? const Center(child: CircularProgressIndicator()) :
        _products.isEmpty ? const Center(child: Text("No Products added yet", style: TextStyle(color: Colors.white),),) :
        RefreshIndicator(
          onRefresh: _getProducts,
          child: ListView.separated(
            controller: _controller,
            physics: const BouncingScrollPhysics(),
            itemCount: _products.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  height: size.width*0.15,
                  width: size.width,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: size.width*0.15,
                        backgroundColor: Colors.transparent,
                        child: CachedNetworkImage(
                            imageUrl: _products[index].get('url'),
                            progressIndicatorBuilder: (context, url,
                                downloadProgress) =>
                                CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  color: Colors.black,),
                            imageBuilder: (context, imageProvider) =>
                                Container(
                                  decoration: BoxDecoration(
                                      shape:BoxShape.circle,
                                      image:DecorationImage(
                                          image:imageProvider,
                                          fit: BoxFit.cover
                                      )
                                  ),
                                )
                        ),
                      ),
                      //const SizedBox(width: 10,),
                      Container(
                        width: size.width*0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_products[index].get('name'), style: const TextStyle(fontSize: 20, color: Colors.white),),
                                Text('\u{20B9}' + _products[index].get('prince') + '/-', style: const TextStyle(fontSize: 16, color: Colors.white),),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Flexible(child: Text(_products[index].get('description'), overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: Colors.grey.shade500),))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 15,); },
          ),
        ),
      ),
    );
  }
}
