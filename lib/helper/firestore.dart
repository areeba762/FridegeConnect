
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  String userId = FirebaseAuth.instance.currentUser!.uid;


  Future<QuerySnapshot<Map<String, dynamic>>> getFridgeItems() {
    return FirebaseFirestore.instance.collection('Users').doc(userId).collection(
        'usersData').get();
  }
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

  Future<void> addLDataOfUsers( category,  name, quantity,
      shelfNo) async {


    // Check if the item already exists in the database
    CollectionReference userItemsCollection = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('usersData');

    QuerySnapshot<Object?> snapshot = await userItemsCollection
        .where('Category', isEqualTo: category)
        .where('ItemName', isEqualTo: name)
        .get();

    if (snapshot.docs.isEmpty) {
      // If the item does not exist, add it as a new entry
      await userItemsCollection.add({
        'Category': category,
        'ItemName': name,
        'Quantity': quantity,
        'ShelfNo': shelfNo,
      });
    } else {
      // If the item already exists, update its quantity
      DocumentReference docRef = snapshot.docs.first.reference;
      await docRef.update({
        'Quantity': FieldValue.increment(quantity),
        'ShelfNo': shelfNo,
      });
    }
  }
}
//   Future<void> addLDataOfUsers(category,name,quantity,shelfNo) async {
//     final ref = FirebaseFirestore.instance
//         .collection('Users')
//         .doc(FirebaseAuth.instance.currentUser!.uid).collection('usersData').doc();
//     var data1 = {
//       'Category' : category,
//       'ItemName' : name,
//       'Quantity': quantity,
//       'ShelfNo' : shelfNo,
//     };
//
//
//     await ref.set(data1, SetOptions(merge: true)); // create/update
//   }
//
// }
