import 'package:flutter/material.dart';
import 'package:shopping_app/product_cart.dart';
import 'package:shopping_app/product_details_page.dart';
import 'package:shopping_app/product_model.dart';
import 'package:shopping_app/user_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/services/product_firestore_services.dart';

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
    final productService = ProductFirestoreServices();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child:  SizedBox(height: 10)),
            const SliverToBoxAdapter(child:  UserHeader()),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            const SliverToBoxAdapter(
              child: Text(
                'Shoes \nCollection',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SliverToBoxAdapter(child: const SizedBox(height: 16)),
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
            const SliverToBoxAdapter(child:  SizedBox(height: 16)),

            //Filter CHIPS
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
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            StreamBuilder<QuerySnapshot>(
              stream: productService.getProduct(),
              builder: (context, snapshot) {     
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                 if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }
                final docs = snapshot.data!.docs ?? [];
                 if (docs.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('No products available'),
                    ),
                  );
                }

                List<Product> allProducts = docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Product(
                    id: doc.id,
                    title: data['title'],
                    price: data['price'] != null
                    ? (data['price'] as num).toDouble()
                    : 0.0,
                    imageUrl: data['image']?.toString() ?? '',
                    company: data['company']?.toString() ?? 'Unknown',

                    sizes: data['sizes'] != null
                        ? List<int>.from(data['sizes'])
                        : [],
                  );
                }).toList();

                //Filter + Search 
                final filteredProducts = allProducts.where((product) {
                  final matchesFilter =
                      selectedFilter == 'All' ||
                      product.company == selectedFilter;

                  final matchesSearch = product.title.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
                  return matchesFilter && matchesSearch;
                }).toList();

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
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
                        title: product.title,
                        price: product.price,
                        image: product.imageUrl,
                        backgroundColor: index.isEven
                            ? const Color.fromRGBO(216, 240, 253, 1)
                            : const Color.fromRGBO(245, 247, 249, 1),
                      ),
                    );
                  }, childCount: filteredProducts.length),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
