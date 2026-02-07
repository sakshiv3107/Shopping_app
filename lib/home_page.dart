import 'package:flutter/material.dart';
import 'package:shopping_app/cart_page.dart';
import 'package:shopping_app/product_list.dart';
import 'package:shopping_app/services/auth_service.dart';
import 'package:shopping_app/order_history_page.dart';   // 👈 NEW

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  final AuthService authService = AuthService();

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      const ProductList(),

      CartPage(
        onGoHome: () {
          setState(() {
            currentPage = 0;
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentPage == 0
          ? AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              elevation: 0,

              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(width: 8),
                  Text(
                    'Shopping App',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),

              actions: [
                // 🧾 ORDER HISTORY BUTTON
                IconButton(
                  tooltip: "My Orders",
                  icon: const Icon(Icons.receipt_long_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrderHistoryPage(),
                      ),
                    );
                  },
                ),

                // LOGOUT BUTTON
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Log Out'),
                        content: const Text(
                          'Are you sure you want to log out?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.pop(dialogContext);
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
            )
          : null,

      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),

      floatingActionButton: currentPage == 1
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() => currentPage = 1);
              },
              child: const Icon(Icons.shopping_cart),
            ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,
    );
  }
}
