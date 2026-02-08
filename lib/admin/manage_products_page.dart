import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_product_page.dart';

class ManageProductsPage extends StatelessWidget {
  const ManageProductsPage({super.key});

  Stream<QuerySnapshot> productStream() {
    return FirebaseFirestore.instance
        .collection('products')
        .snapshots();
  }

  Future<void> deleteProduct(String id, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(id)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Product Deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Products")),

      body: StreamBuilder<QuerySnapshot>(
        stream: productStream(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return const Center(child: Text("No Products Added"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,

            itemBuilder: (context, index) {
              final data =
                  products[index].data() as Map<String, dynamic>;

              final id = products[index].id;

              return Card(
                margin: const EdgeInsets.only(bottom: 10),

                child: ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(data['image']),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  title: Text(data['title'] ?? ''),
                  subtitle: Text(
                      "₹${data['price']} • ${data['company']}"),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // ✏ EDIT
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),

                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddProductPage(
                                productId: id,
                                productData: data,
                              ),
                            ),
                          );
                        },
                      ),

                      // 🗑 DELETE
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),

                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Delete Product"),
                              content: const Text(
                                  "Are you sure to delete?"),

                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context),
                                  child: const Text("No"),
                                ),

                                TextButton(
                                  onPressed: () {
                                    deleteProduct(id, context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Yes",
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
          );
        },
      ),
    );
  }
}
