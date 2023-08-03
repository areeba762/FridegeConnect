import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fridge_app/helper/edit_task.dart';

class fridge_items_tab extends StatefulWidget {
  @override
  _FridgeItemsTabState createState() => _FridgeItemsTabState();
}

class _FridgeItemsTabState extends State<fridge_items_tab> {
  User? user;

  @override
  void initState() {
    super.initState();
    // Fetch the current user when the widget is initialized
    user = FirebaseAuth.instance.currentUser;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Fridge Items'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('usersData')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {

                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  try {
                    final link = snapshot.data!;

                    print(link.docs.first.data());

                    print(link.docs[0].id);
                    return ListView.builder(
                        itemCount: link.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(link.docs[index]['ItemName'] ??
                                'Item Not fetched'),
                            subtitle: Text(
                                link.docs[index]['Quantity'].toString() ??
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateItem(
                                      docId: link.docs[index].id.toString(),
                                    )),
                              );

                            },
                          );
                        });
                  } catch (error) {
                    return Center(
                      child: Text('Error1: $error'),
                    );
                  }
                } else {
                  return const Center(child: Text('No data available.'));
                }

              },
            ),
          ),
        ],
      ),
    );
  }
}