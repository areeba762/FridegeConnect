import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FridgeItemsPage extends StatefulWidget {
  @override
  _FridgeItemsPageState createState() => _FridgeItemsPageState();
}

class _FridgeItemsPageState extends State<FridgeItemsPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('fridge_items');

  List<FridgeItem> _fridgeItems = [];

  @override
  void initState() {
    super.initState();
    _loadFridgeItems();
  }

  Future<void> _loadFridgeItems() async {
    final dataSnapshot = await _database.once();
    final value = dataSnapshot.snapshot.value;
    if (value != null && value is Map<dynamic, dynamic>) {
      setState(() {
        _fridgeItems = value.entries
            .map((e) => FridgeItem(
          id: e.key,
          name: e.value['name'],
          quantity: e.value['quantity'],
          category: e.value['category'],
          shelfNumber: e.value['shelfNumber']
        ))
            .toList();
      });
    }
  }
  Future<void> _deleteFridgeItem(String id) async {
    await _database.child(id).remove();
    setState(() {
      _fridgeItems.removeWhere((item) => item.id == id);
    });
  }

  Future<void> _editFridgeItem(FridgeItem item) async {
    final String newName = await showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController =
        TextEditingController(text: item.name);
        return AlertDialog(
          title: Text('Edit Item Name'),
          content: TextField(controller: nameController),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, nameController.text.trim()),
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      await _database.child(item.id).update({'name': newName});
      setState(() {
        item.name = newName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fridge Items')),
      body: ListView.builder(
        itemCount: _fridgeItems.length,
        itemBuilder: (context, index) {
          final item = _fridgeItems[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantity: ${item.quantity}'),
                Text('Category: ${item.category}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editFridgeItem(item),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteFridgeItem(item.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FridgeItem {
  String id;
  String name;
  int quantity;
  String category;
  int shelfNumber;

  FridgeItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.shelfNumber,
  });
}



