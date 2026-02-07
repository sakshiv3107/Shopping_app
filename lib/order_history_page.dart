import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'services/order_service.dart';
import 'order_detail_page.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  String formatDate(Timestamp ts) {
    final date = ts.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final orderService = OrderService();

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders"), centerTitle: true),

      floatingActionButton: FloatingActionButton(
        tooltip: "Go to Home",
        child: const Icon(Icons.home),
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: StreamBuilder<QuerySnapshot>(
        stream: orderService.getUserOrders(),

        builder: (context, snapshot) {

          // 1. LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. ERROR
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // 3. NO DATA
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Orders Yet"));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,

            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;

              print("ORDER → $data");   // DEBUG

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                child: ListTile(
                  title: Text(
                    "Order #${orders[index].id.substring(0, 6)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total: ₹${data['totalPrice'] ?? 0}"),
                      Text("Status: ${data['orderStatus'] ?? 'Unknown'}"),

                      if (data['createdAt'] != null)
                        Text("Date: ${formatDate(data['createdAt'])}"),
                    ],
                  ),

                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailPage(
                          orderId: orders[index].id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
