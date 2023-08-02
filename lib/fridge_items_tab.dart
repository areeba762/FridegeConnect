import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  List<String> _categories = ['Fruits', 'Vegetables', 'Dairy', 'Meat', 'Others'];

  // void _addNewItem() {
  //   String itemName = _itemNameController.text.trim();
  //   double quantity = double.tryParse(_quantityController.text.trim()) ?? 0.0;
  //   int shelfNumber = int.tryParse(_shelfNumberController.text.trim()) ?? 0;
  //
  //   if (itemName.isEmpty || quantity <= 0 || shelfNumber <= 0 || _selectedCategory == null || _selectedCategory!.isEmpty) {
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('Error'),
  //         content: Text('Please fill all the fields.'),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //     return;
  //   }
  //
  //   // Save the item to Firestore
  //   FirebaseFirestore.instance.collection('fridge_items').add({
  //     'itemName': itemName,
  //     'quantity': quantity,
  //     'shelfNumber': shelfNumber,
  //     'category': _selectedCategory,
  //   }).then((_) {
  //     // Clear the form after successful item addition
  //     _itemNameController.clear();
  //     _quantityController.clear();
  //     _shelfNumberController.clear();
  //     _selectedCategory = '';
  //     setState(() {}); // Refresh the UI to display the new item
  //   }).catchError((error) {
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('Error'),
  //         content: Text('Failed to add item to the database.'),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //   });
  // }

  void _deleteItem(String itemId) {
    // Implement delete item functionality using Firestore
    FirebaseFirestore.instance.collection('fridge_items').doc(itemId).delete().then((_) {
      // Item deleted successfully
      setState(() {});
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete item from the database.'),
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

  void _editItem(String itemId, String itemName, double quantity, int shelfNumber, String category) {
    _itemNameController.text = itemName;
    _quantityController.text = quantity.toString();
    _shelfNumberController.text = shelfNumber.toString();
    _selectedCategory = category;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
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
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              // Implement edit item functionality using Firestore
              FirebaseFirestore.instance.collection('fridge_items').doc(itemId).update({
                'itemName': _itemNameController.text.trim(),
                'quantity': double.tryParse(_quantityController.text.trim()) ?? 0.0,
                'shelfNumber': int.tryParse(_shelfNumberController.text.trim()) ?? 0,
                'category': _selectedCategory,
              }).then((_) {
                // Item updated successfully
                setState(() {});
              }).catchError((error) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Error'),
                    content: Text('Failed to update item in the database.'),
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
            child: Text('Save'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Fridge Items'),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: EdgeInsets.all(16.0),
          //   child: Column(
          //     children: [
          //       TextFormField(
          //         controller: _itemNameController,
          //         decoration: InputDecoration(labelText: 'Item Name'),
          //       ),
          //       TextFormField(
          //         controller: _quantityController,
          //         keyboardType: TextInputType.number,
          //         decoration: InputDecoration(labelText: 'Quantity'),
          //       ),
          //       TextFormField(
          //         controller: _shelfNumberController,
          //         keyboardType: TextInputType.number,
          //         decoration: InputDecoration(labelText: 'Shelf Number'),
          //       ),
          //       GestureDetector(
          //         onTap: () {
          //           showDialog(
          //             context: context,
          //             builder: (BuildContext context) {
          //               return AlertDialog(
          //                 title: Text('Select Category'),
          //                 content: Container(
          //                   width: double.maxFinite,
          //                   child: ListView.builder(
          //                     shrinkWrap: true,
          //                     itemCount: _categories.length,
          //                     itemBuilder: (context, index) {
          //                       return ListTile(
          //                         title: Text(_categories[index]),
          //                         onTap: () {
          //                           setState(() {
          //                             _selectedCategory = _categories[index];
          //                           });
          //                           Navigator.of(context).pop();
          //                         },
          //                       );
          //                     },
          //                   ),
          //                 ),
          //               );
          //             },
          //           );
          //         },
          //         child: InputDecorator(
          //           decoration: InputDecoration(
          //             labelText: 'Category',
          //           ),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(_selectedCategory ?? 'Select Category'),
          //               Icon(Icons.arrow_drop_down),
          //             ],
          //           ),
          //         ),
          //       ),
          //       ElevatedButton(
          //         onPressed: _addNewItem,
          //         child: Text('Add New Product'),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('usersData').doc().snapshots(),
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
                    final link = snapshot.data!.data(); // it returns the whole document inside link variable

                    String itemname = link?['ItemName'] ?? 'h';
                    double itemquantity = link?['Quantity'] ?? 0.0;
                    int shelfno = link?['ShelfNo'] ?? 0;
                    String category = link?['Category'] ?? '';
                    String itemId;
                        return ListView.builder(
                            itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(itemname),
                              subtitle: Text(itemquantity.toString()),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // _deleteItem(itemId);
                                },
                              ),
                              onTap: () {
                                // _editItem(itemId, link?['ItemName'], link?['Quantity'], link?['ShelfNo'], link?['Category']);
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

                    // if (snapshot.hasData) {
                //   List<DocumentSnapshot> items = snapshot.data!.docs;
                //   return ListView.builder(
                //     itemCount: items.length,
                //     itemBuilder: (context, index) {
                //       Map<String, dynamic> data = items[index].data() as Map<String, dynamic>;
                //       String itemId = items[index].id;

                // }
                // else {
                //   return Center(child: CircularProgressIndicator());
                // }
              },
            ),
          ),
        ],
      ),
    );
  }
}
