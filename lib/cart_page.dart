import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/services/cart_firestore_service.dart';
import 'package:shopping_app/checkout_page.dart';

class CartPage extends StatelessWidget {
  final VoidCallback onGoHome;
  const CartPage({super.key, required this.onGoHome});

  Stream<QuerySnapshot> cartStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final cartService = CartFirestoreService();

    return StreamBuilder<QuerySnapshot>(
      stream: cartStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final cartDocs = snapshot.data!.docs;

        double totalPrice = 0;
        for (var doc in cartDocs) {
          final data = doc.data() as Map<String, dynamic>;
          totalPrice += (data['price'] as num) * (data['quantity'] as num);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Cart'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onGoHome,
            ),
          ),

          // HOME FLOATING BUTTON 
          
          floatingActionButton: FloatingActionButton(
            onPressed: onGoHome,
            child: const Icon(Icons.home),
          ),

          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,

          // 
          // MAIN BODY 
          
          body: cartDocs.isEmpty
              ? Center(
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
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 120),
                  itemCount: cartDocs.length,
                  itemBuilder: (context, index) {
                    final item =
                        cartDocs[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // IMAGE
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

                            // INFO
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text('Size: ${item['size']}'),

                                  const SizedBox(height: 6),

                                  // QUANTITY CONTROLS
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          cartService.updateQty(
                                            cartDocs[index].id,
                                            -1,
                                          );
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
                                          cartService.updateQty(
                                            cartDocs[index].id,
                                            1,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // DELETE
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
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
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          cartService.deleteProduct(
                                            cartDocs[index].id,
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Yes',
                                          style:
                                              TextStyle(color: Colors.red),
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

          //  BOTTOM SECTION 
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),

              child: Row(
                children: [
                  // TOTAL
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // CHECKOUT BUTTON
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: cartDocs.isEmpty
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const CheckoutPage(),
                                ),
                              );
                            },
                      child: const Text('Checkout'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
