import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'helper/firestore.dart';


class add_fridge_items extends StatefulWidget {
  const add_fridge_items({Key? key}) : super(key: key);

  @override
  State<add_fridge_items> createState() => _add_fridge_itemsState();
}

class _add_fridge_itemsState extends State<add_fridge_items> {
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

  List<String> _categories = ['Fruits', 'Vegetables', 'Dairy', 'Meat', 'Others'];
  void _addNewItem() async{
    String itemName = _itemNameController.text.trim();
    double quantity = double.tryParse(_quantityController.text.trim()) ?? 0.0;
    int shelfNumber = int.tryParse(_shelfNumberController.text.trim()) ?? 0;

    if (itemName.isEmpty || quantity <= 0 || shelfNumber <= 0 || _selectedCategory == null || _selectedCategory!.isEmpty) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text('Please fill all the fields.'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
      return;
    }
       FirestoreService().addLDataOfUsers(_selectedCategory, itemName, quantity, shelfNumber).then((_) {
        // Clear the form after successful item addition
        _itemNameController.clear();
        _quantityController.clear();
        _shelfNumberController.clear();
        _selectedCategory = '';
        setState(() {}); // Refresh the UI to display the new item
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
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

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _itemNameController,
                    decoration: InputDecoration(labelText: 'Item Name'),
                  ),
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Quantity'),
                  ),
                  TextFormField(
                    controller: _shelfNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Shelf Number'),
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
                  ElevatedButton(
                    onPressed: _addNewItem,
                    child: Text('Add New Product',
                      style: TextStyle(color: Colors.white),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple), // Change the color here
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

