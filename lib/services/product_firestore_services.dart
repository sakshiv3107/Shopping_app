import 'package:cloud_firestore/cloud_firestore.dart';

class ProductFirestoreServices {
  final _db = FirebaseFirestore.instance;
  Stream<QuerySnapshot> getProduct() {
    return _db.collection('products').snapshots();
  }
}
