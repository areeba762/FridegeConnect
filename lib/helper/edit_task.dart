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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text('Update Item'),
          ),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Item Name',
            ),
          ),
          ElevatedButton(onPressed: () async {
            FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('usersData').doc(widget.docId).update({
              'ItemName': nameController.text,
            });


          }, child: Text("Update this ")),
        ],
      ),
    );
  }
}
