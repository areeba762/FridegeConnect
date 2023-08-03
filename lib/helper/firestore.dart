
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {

  // We create a new user doc so we could use it later
  Future<void> createUserDoc() async {

    final ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid).collection('usersData').doc(); // links/some-unique-id

    var data = {
      'Category' : 'Fruits',
      'ItemName' : 'Orange',
      'Quantity': '3',
      'ShelfNo' : '4',
    };

   // await ref.set(data, SetOptions(merge: true)); // creates the document in firestore
  }
  Future<QuerySnapshot<Map<String,dynamic>>> getFridgeItems()  {
    return FirebaseFirestore.instance.collection('Users').doc().collection('usersData').get();

  }

  Future<void> addLDataOfUsers(category,name,quantity,shelfNo) async {
    final ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid).collection('usersData').doc();
    var data1 = {
      'Category' : category,
      'ItemName' : name,
      'Quantity': quantity,
      'ShelfNo' : shelfNo,
    };


    await ref.set(data1, SetOptions(merge: true)); // create/update
  }

}
