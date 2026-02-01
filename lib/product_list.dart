import 'package:flutter/material.dart';
import 'package:shopping_app/global_variables.dart';
import 'package:shopping_app/product_cart.dart';
import 'package:shopping_app/product_details_page.dart';
import 'package:shopping_app/product_model.dart';
import 'package:shopping_app/user_header.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String selectedFilter = 'All';
  String searchQuery = '';

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
    final List<Product> filteredProducts = products.where((product) {
      final matchesFilter =
          selectedFilter == 'All' || product.company == selectedFilter;

      final matchesSearch = product.title.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      return matchesFilter && matchesSearch;
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: const SizedBox(height: 10)),
            SliverToBoxAdapter(child: const UserHeader()),
            SliverToBoxAdapter(child: const SizedBox(height: 8)),
            SliverToBoxAdapter(
              child: const Text(
                'Shoes \nCollection',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
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
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: SizedBox(
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
                      selectedColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: const Color.fromRGBO(245, 247, 249, 1),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : Colors.black,
                        fontSize: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 20)),

            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = filteredProducts[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsPage(product: product),
                      ),
                    );
                  },
                  child: ProductCart(
                    title: product.title,
                    price: product.price,
                    image: product.imageUrl,
                    backgroundColor: index.isEven
                        ? const Color.fromRGBO(216, 240, 253, 1)
                        : const Color.fromRGBO(245, 247, 249, 1),
                  ),
                );
              }, childCount: filteredProducts.length),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
