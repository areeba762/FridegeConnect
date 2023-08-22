import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'admob/admob_manager.dart';
//import 'admob/screen_banner_ads.dart';
import 'helper/edit_task.dart';

class fridge_items_tab extends StatefulWidget {
  @override
  _FridgeItemsTabState createState() => _FridgeItemsTabState();
}

class _FridgeItemsTabState extends State<fridge_items_tab> {
  BannerAd? _bannerAd;
  User? user;


  @override
  void initState() {
    super.initState();
    // Fetch the current user when the widget is initialized
    user = FirebaseAuth.instance.currentUser;

    BannerAd(
      adUnitId: AdmobManager.banner_id,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }
  @override
  void dispose() {
    super.dispose();
  }




  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _shelfNumberController = TextEditingController();
  String? _selectedCategory;

  List<String> _categories = [
    'Fruits',
    'Vegetables',
    'Dairy',
    'Meat',
    'Others'
  ];

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fridge Items'),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('usersData').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading spinner while waiting for the data
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // Show an error message if there's an error
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    try {
                      final link = snapshot.data!;

                      print(link.docs.first.data());

                      print(link.docs[0].id);// it returns the whole document inside link variable

                          return ListView.builder(
                              itemCount: link.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(link.docs[index]['ItemName'] ??
                                    'Item Not fetched'),
                                subtitle: Text(link.docs[index]['Quantity'].toString() ??
                                    '0.0'),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(FirebaseAuth.instance.currentUser!.uid)
                                        .collection('usersData')
                                        .doc(link.docs[index].id).delete();
                                  },
                                ),
                                onTap: () {
                                  Get.to(() => UpdateItem(
                                    docId: link.docs[index].id.toString(),),
                                      transition: Transition.fade, duration: Duration(seconds:1));
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //     builder: (context) => UpdateItem(
                                  //   docId: link.docs[index].id.toString(),
                                  // )),
                                  // );
                                },
                              );
                          }
                          );
                           }catch (error) {
                      return Center(
                      child: Text('Error1: $error'),
                      );
                     }
                   } else {
                    return const Center(
                    child: Text('No data available.')
                  );
               }
                },
              ),
            ),
            if (_bannerAd != null)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: Colors.grey,
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
          ],
        ),

      ),
    );
  }
}
