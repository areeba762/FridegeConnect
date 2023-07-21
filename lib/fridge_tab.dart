import 'package:flutter/material.dart';
import 'LoginView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

import 'fridge_items.dart';


class FridgeItemListTab extends StatefulWidget {
  @override
  _FridgeItemListTabState createState() => _FridgeItemListTabState();
}

class _FridgeItemListTabState extends State<FridgeItemListTab> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('fridge_items');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _shelfNumberController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  List<FridgeItem> _fridgeItems = [];

  @override
  void initState() {
    super.initState();

  }


  Future<void> _addFridgeItem() async {
    final String id = Uuid().v4();
    final String name = _nameController.text.trim();
    final int quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final String category = _categoryController.text.trim();
    final int shelfNumber = int.tryParse(_shelfNumberController.text.trim()) ?? 0;

    if (name.isNotEmpty && quantity > 0 && category.isNotEmpty) {
      await _database.child(id).set({
        'name': name,
        'quantity': quantity,
        'category': category,
        'shelfNumber': shelfNumber,
      });

      setState(() {
        _fridgeItems.add(FridgeItem(
          id: id,
          name: name,
          quantity: quantity,
          category: category,
          shelfNumber: shelfNumber,
        ));
      });

      _nameController.clear();
      _quantityController.clear();
      _categoryController.clear();
      _shelfNumberController.clear();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FridgeItemsPage()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Item List in Fridge')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('images/itemlist_logo.png',
              height:150,
              width:150,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Item Name'),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: _shelfNumberController,
                    decoration: InputDecoration(labelText: 'Shelf Number'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(labelText: 'Category'),
                  ),
                  SizedBox(height: 5.0),
                  ElevatedButton(
                    onPressed: _addFridgeItem,
                    child: Text('Add New Product',
                      style: TextStyle(color: Colors.white),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple), // Change the color here
                    ),),
                ],
              ),
            ),
          ],
        ),
      ),

    );


  }
}