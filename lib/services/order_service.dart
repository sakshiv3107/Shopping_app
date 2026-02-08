import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  final _db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot> getUserOrders() {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: _uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot> getOrderById(String id) {
    return _db.collection('orders').doc(id).get();
  }

  Stream<QuerySnapshot> getAllOrders() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateStatus(String orderId, String status) async {
    await _db.collection('orders').doc('orderId').update({
      'orderStatus': status,
    });
  }
}
