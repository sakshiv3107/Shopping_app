import 'package:shopping_app/services/order_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;
  // final VoidCallback onGoHome;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final orderService = OrderService();
    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      floatingActionButton: FloatingActionButton(
            tooltip: "Go Home",
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Icon(Icons.home),
          ),

      floatingActionButtonLocation:
        FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder<DocumentSnapshot>(
        future: orderService.getOrderById(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final items = List<Map<String, dynamic>>.from(data['items']);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order ID: $orderId",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Text("Status: ${data['orderStatus']}"),
                Text("Payment: ${data['paymentMethod']}"),
                Text("Address: ${data['address']}"),

                const Divider(height: 30),

                const Text(
                  "Items",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                ...items.map((item) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        item['title'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        "Qty: ${item['quantity']}  |  Size: ${item['size']}",
                      ),
                      trailing: Text(
                        "₹${item['price']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                    ),
                  );
                }),
                const SizedBox(height: 20),

                Text(
                  "Total: ₹${data['totalPrice']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
