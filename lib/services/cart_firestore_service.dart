import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartFirestoreService {
  final _db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> addToCart({
    required String productId,
    required String title,
    required double price,
    required String image,
  }) async {
    final docref = _db
        .collection('users')
        .doc(_uid)
        .collection('cart')
        .doc(productId);

    final doc = await docref.get();

    if (doc.exists) {
      await docref.update({'quantity': FieldValue.increment(1)});
    } else {
      await docref.set({
        'title': title,
        'price': price,
        'image': image,
        'quantity': 1,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> updateQty(String productId, int change) async {
    final docref = _db
        .collection('users')
        .doc(_uid)
        .collection('cart')
        .doc(productId);

    final doc = await docref.get();

    if (!doc.exists) return;
    final currentQty = doc['quantity'];
    if (currentQty + change <= 0) {
      await docref.delete();
    } else {
      await docref.update({'quantity': FieldValue.increment(change)});
    }
  }

  Future<void> deleteProduct(String productId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(productId)
        .delete();
  }
}
