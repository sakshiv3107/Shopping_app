import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:shopping_app/services/cart_firestore_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressController = TextEditingController();
  String _paymentMethod = 'Card';
  bool _placingOrder = false;

  Stream<QuerySnapshot> _cartStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .snapshots();
  }

  Future<void> _placeOrder(List<QueryDocumentSnapshot> cartDocs) async {
    if (cartDocs.isEmpty) return;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a shipping address')),
      );
      return;
    }

    setState(() => _placingOrder = true);

    try {
      final items = cartDocs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'productId': doc.id,
          'title': data['title'],
          'price': data['price'],
          'quantity': data['quantity'],
          'image': data['image'],
          'size': data['size'],
        };
      }).toList();

      double total = 0;
      for (var it in items) {
        total += (it['price'] as num) * (it['quantity'] as num);
      }

      // Create order document
      final orderRef = await FirebaseFirestore.instance
          .collection('orders')
          .add({
            'userId': uid,
            'items': items,
            'totalPrice': total,
            'address': _addressController.text.trim(),
            'paymentMethod': _paymentMethod,
            'orderStatus': 'placed',
            'createdAt': FieldValue.serverTimestamp(),
          });

      // Clear cart
      final batch = FirebaseFirestore.instance.batch();
      final cartCol = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart');
      for (var doc in cartDocs) {
        batch.delete(cartCol.doc(doc.id));
      }
      await batch.commit();

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Order Placed'),
          content: Text('Your order (${orderRef.id}) was placed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((r) => r.isFirst);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
    } finally {
      if (mounted) setState(() => _placingOrder = false);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final cartService = CartFirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: _cartStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData){
            return const Center(child: CircularProgressIndicator());}
          final cartDocs = snapshot.data!.docs;

          double totalPrice = 0;
          for (var doc in cartDocs) {
            final data = doc.data() as Map<String, dynamic>;
            totalPrice += data['price'] * data['quantity'];
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shipping Address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter shipping address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Payment Method',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        value: 'Card',
                        groupValue: _paymentMethod,
                        title: const Text('Credit / Debit Card'),
                        onChanged: (v) => setState(() => _paymentMethod = v!),
                      ),
                      RadioListTile<String>(
                        value: 'UPI',
                        groupValue: _paymentMethod,
                        title: const Text('UPI'),
                        onChanged: (v) => setState(() => _paymentMethod = v!),
                      ),
                      RadioListTile<String>(
                        value: 'COD',
                        groupValue: _paymentMethod,
                        title: const Text('Cash on Delivery'),
                        onChanged: (v) => setState(() => _paymentMethod = v!),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Order Summary',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),

                // Items
                ...cartDocs.map((doc) {
                  final item = doc.data() as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage(item['image']),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      title: Text(item['title']),
                      subtitle: Text(
                        'Size: ${item['size']}  x${item['quantity']}',
                      ),
                      trailing: Text(
                        '\$${(item['price'] as num).toStringAsFixed(2)}',
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _placingOrder
                        ? null
                        : () => _placeOrder(
                            cartDocs ,
                          ),
                    child: _placingOrder
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Place Order'),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
