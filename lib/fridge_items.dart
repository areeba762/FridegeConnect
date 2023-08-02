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
    // Save the item to Firestore
    // FirebaseFirestore.instance.collection('fridge_items').add({
    //   'itemName': itemName,
    //   'quantity': quantity,
    //   'shelfNumber': shelfNumber,
    //   'category': _selectedCategory,
    // }).then((_) {
    //   // Clear the form after successful item addition
    //   _itemNameController.clear();
    //   _quantityController.clear();
    //   _shelfNumberController.clear();
    //   _selectedCategory = '';
    //   setState(() {}); // Refresh the UI to display the new item
    // }).catchError((error) {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: Text('Error'),
    //       content: Text('Failed to add item to the database.'),
    //       actions: [
    //         ElevatedButton(
    //           onPressed: () => Navigator.pop(context),
    //           child: Text('OK'),
    //         ),
    //       ],
    //     ),
    //   );
    // });
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
                    child: Text('Add New Product'),
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


// class FridgeItemsPage extends StatefulWidget {
//   @override
//   _FridgeItemsPageState createState() => _FridgeItemsPageState();
// }
//
// class _FridgeItemsPageState extends State<FridgeItemsPage> {
//   final DatabaseReference _database = FirebaseDatabase.instance.ref().child('fridge_items');
//
//   List<FridgeItem> _fridgeItems = [];
//   List<String> _categories = [];
//   String? _selectedCategory;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loadFridgeItems();
//     _loadCategories();
//   }
//
//   Future<void> _loadFridgeItems() async {
//     final dataSnapshot = await _database.once();
//     final value = dataSnapshot.snapshot.value;
//     if (value != null && value is Map<dynamic, dynamic>) {
//       setState(() {
//         _fridgeItems = value.entries
//             .map((e) => FridgeItem(
//           id: e.key,
//           name: e.value['name'],
//           quantity: e.value['quantity'],
//           category: e.value['category'],
//           shelfNumber: e.value['shelfNumber']
//         ))
//             .toList();
//       });
//     }
//   }
//   Future<void> _loadCategories() async {
//     final dataSnapshot = await FirebaseDatabase.instance.ref().child('categories').once();
//     final value = dataSnapshot.snapshot.value;
//     if (value != null && value is List<dynamic>) {
//       setState(() {
//         _categories = value.cast<String>();
//       });
//     }
//   }
//   Future<void> _deleteFridgeItem(String id) async {
//     await _database.child(id).remove();
//     setState(() {
//       _fridgeItems.removeWhere((item) => item.id == id);
//     });
//   }
//
//   Future<void> _editFridgeItem(FridgeItem item) async {
//     final String newName = await showDialog(
//       context: context,
//       builder: (context) {
//         final TextEditingController nameController =
//         TextEditingController(text: item.name);
//         return AlertDialog(
//           title: Text('Edit Item Name'),
//           content: TextField(controller: nameController),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () =>
//                   Navigator.pop(context, nameController.text.trim()),
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (newName != null && newName.isNotEmpty) {
//       await _database.child(item.id).update({'name': newName});
//       setState(() {
//         item.name = newName;
//       });
//     }
//   }
//   void _showAddCategoryDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         final TextEditingController categoryController = TextEditingController();
//         return AlertDialog(
//           title: Text('Add New Category'),
//           content: TextField(controller: categoryController),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 final newCategory = categoryController.text.trim();
//                 if (newCategory.isNotEmpty) {
//                   setState(() {
//                     _categories.add(newCategory);
//                     _selectedCategory = newCategory;
//                   });
//                 }
//                 Navigator.pop(context);
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Fridge Items')),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: DropdownButtonFormField<String>(
//               decoration: InputDecoration(labelText: 'Select Category'),
//               value: _selectedCategory,
//               items: _categories.map((category) {
//                 return DropdownMenuItem<String>(
//                   value: category,
//                   child: Text(category),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedCategory = value;
//                 });
//               },
//               onSaved: (value) {
//                 _selectedCategory = value;
//               },
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _fridgeItems.length,
//               itemBuilder: (context, index) {
//                 final item = _fridgeItems[index];
//                 return ListTile(
//                   title: Text(item.name),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Quantity: ${item.quantity}'),
//                       Text('Category: ${item.category}'),
//                     ],
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.edit),
//                         onPressed: () => _editFridgeItem(item),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () => _deleteFridgeItem(item.id),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddCategoryDialog,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
//
// class FridgeItem {
//   String id;
//   String name;
//   int quantity;
//   String category;
//   int shelfNumber;
//
//   FridgeItem({
//     required this.id,
//     required this.name,
//     required this.quantity,
//     required this.category,
//     required this.shelfNumber,
//   });
// }
//
//
//
