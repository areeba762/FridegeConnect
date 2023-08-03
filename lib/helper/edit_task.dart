import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateItem extends StatefulWidget {
  final String docId;

  const UpdateItem({super.key, required this.docId});

  @override
  State<UpdateItem> createState() => _UpdateItemState();
}

class _UpdateItemState extends State<UpdateItem> {

  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  //final categoryController = TextEditingController();
  final shelfNoController= TextEditingController();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height:60),
              Center(
                child: Text('Update Item'),
              ),
              SizedBox(height:20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                ),
              ),
              SizedBox(height:20),
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                ),
              ),
              SizedBox(height:20),
              TextFormField(
                controller: shelfNoController,
                decoration: InputDecoration(
                  labelText: 'Shelf No',
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Select Category'),
                        content: Container(
                          width: double.maxFinite,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_categories[index]),
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = _categories[index];
                                  });
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Category',
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_selectedCategory ?? 'Select Category'),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),


              SizedBox(height:20),
              ElevatedButton(onPressed: () async {
                FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('usersData').doc(widget.docId).update({
                  'ItemName': nameController.text,
                  'Quantity': quantityController.text,
                  'Category' : _selectedCategory.toString(),
                  'Shelf No' : shelfNoController.text,
                }).then((_) {
                  nameController.clear();
                  quantityController.clear();
                  shelfNoController.clear();
                  _selectedCategory = '';
                  setState(() {});  }).catchError((error) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to add item to the database.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  });
                },
                  child: Text("Update",
                    style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple), // Change the color here
                ),),
            ],

          ),
          ),
        ),
      );

  }
}