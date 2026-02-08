import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/order_service.dart';
import '../pages/order_detail_page.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  Color statusColor(String orderStatus) {
    switch (orderStatus) {
      case 'placed':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = OrderService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Orders"),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: service.getAllOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(child: Text("No Orders Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data =
                  orders[index].data() as Map<String, dynamic>;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    "Order #${orders[index].id.substring(0, 6)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User: ${data['userId']}"),
                      Text("Total: ₹${data['totalPrice']}"),

                      const SizedBox(height: 4),

                      // STATUS CHIP
                      Chip(
                        label: Text(data['orderStatus']),
                        backgroundColor:
                            statusColor(data['orderStatus'])
                                .withOpacity(0.2),
                        labelStyle: TextStyle(
                          color:
                              statusColor(data['orderStatus']),
                        ),
                      ),
                    ],
                  ),

                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      print("Updating order: ${orders[index].id} to status: $value");
                      service.updateStatus(
                          orders[index].id, value);
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: "placed",
                        child: Text("Placed"),
                      ),
                      const PopupMenuItem(
                        value: "shipped",
                        child: Text("Shipped"),
                      ),
                      const PopupMenuItem(
                        value: "delivered",
                        child: Text("Delivered"),
                      ),
                    ],
                  ),

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
