import 'package:flutter/material.dart';
import 'package:shopping_app/global_variables.dart';
import 'package:shopping_app/product_cart.dart';
import 'package:shopping_app/product_details_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String selectedFilter = 'All';

  final List<String> filters = const [
    'All',
    'Addidas',
    'Nike',
    'Puma',
    'Reebok',
    'Bata',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = selectedFilter == 'All'
        ? products
        : products
            .where((p) => p['company'] == selectedFilter)
            .toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const SizedBox(height: 10),
            const Text(
              'Shoes \nCollection',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search shoes',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color.fromRGBO(245, 247, 249, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Filters
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final isSelected = selectedFilter == filter;

                  return ChoiceChip(
                    label: Text(filter),
                    showCheckmark: false,
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    selectedColor:
                        Theme.of(context).colorScheme.primary,
                    backgroundColor:
                        const Color.fromRGBO(245, 247, 249, 1),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color.fromARGB(255, 0, 0, 0) : Colors.black,
                      fontSize: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Product List
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailsPage(product: product),
                        ),
                      );
                    },
                    child: ProductCart(
                      title: product['title'] as String ,
                      price: product['price'] as double,
                      image: product['imageUrl'] as String,
                      backgroundColor: index.isEven
                          ? const Color.fromRGBO(216, 240, 253, 1)
                          : const Color.fromRGBO(245, 247, 249, 1),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
