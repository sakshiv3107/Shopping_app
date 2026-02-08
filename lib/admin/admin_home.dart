import 'package:flutter/material.dart';
import 'package:shopping_app/admin/admin_orders_page.dart';
import 'package:shopping_app/admin/manage_products_page.dart';
import 'add_product_page.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  Widget adminCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 28, color: color),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Admin 👋",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 6),

            const Text(
              "Manage your store easily",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            adminCard(
              context: context,
              icon: Icons.add_box_rounded,
              title: "Add Product",
              subtitle: "Create new product for store",
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductPage()),
                );
              },
            ),

            const SizedBox(height: 12),

            adminCard(
              context: context,
              icon: Icons.inventory_2_rounded,
              title: "Manage Products",
              subtitle: "Edit, update or delete products",
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageProductsPage()),
                );
              },
            ),

            const SizedBox(height: 12),

            adminCard(
              context: context,
              icon: Icons.receipt_long_rounded,
              title: "View Orders",
              subtitle: "Check customer orders",
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdminOrdersPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
