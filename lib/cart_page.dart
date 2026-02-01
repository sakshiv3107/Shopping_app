import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/services/cart_firestore_service.dart';

class CartPage extends StatelessWidget {
  final VoidCallback onGoHome;
  const CartPage({super.key, required this.onGoHome});

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> cartStream() {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      return FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart')
          .snapshots();
    }
    final cartService = CartFirestoreService();

    return StreamBuilder<QuerySnapshot>(
      stream: cartStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final cartDocs = snapshot.data!.docs;

        if (cartDocs.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Your cart is empty 🛒'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onGoHome,
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        );
      }

        double totalPrice = 0;

      for (var doc in cartDocs) {
        final data = doc.data() as Map<String, dynamic>;
        totalPrice += data['price'] * data['quantity'];
      }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartDocs.length,
                itemBuilder: (context, index) {
                  final item = cartDocs[index].data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          //  Image
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              image: DecorationImage(
                                image: AssetImage(item['image']),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                // Text('Size: ${item['size']}'),
                                const SizedBox(height: 6),

                                // Quantity controls
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        cartService.updateQty(cartDocs[index].id, -1);
                                      },
                                    ),
                                    Text(
                                      item['quantity'].toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        cartService.updateQty(cartDocs[index].id, 1);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          //  Delete
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Delete Product'),
                                  content: const Text(
                                    'Remove this item from cart?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        cartService.deleteProduct(cartDocs[index].id);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
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
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          ],
        );
      },
    );
  }
}
