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
  late String selectedFilter;

  final List<String> filters = const [
    'All',
    'Addidas',
    'Nike',
    'Puma',
    'Reebok',
    'Bata',
  ];

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(30)),
      borderSide: BorderSide(color: Color.fromRGBO(173, 173, 173, 1)),
    );
    return SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Shoes\nCollection',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search, size: 20),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: filters.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 3.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Chip(
                        backgroundColor: selectedFilter == filter
                            ? Theme.of(context).colorScheme.primary
                            : Color.fromRGBO(245, 247, 249, 1),
                        side: BorderSide(
                          color: Color.fromRGBO(245, 247, 249, 1),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 6,
                        ),
                        label: Text(filter),
                        labelStyle: TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(30),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final productTitle = product['title'];
                  final productPrice = product['price'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ProductDetailsPage(product: product);
                          },
                        ),
                      );
                    },
                    child: ProductCart(
                      title: productTitle as String,
                      price: productPrice as double,
                      image: product['imageUrl'] as String,
                      backgroundColor: index.isEven
                          ? Color.fromRGBO(216, 240, 253, 1)
                          : Color.fromRGBO(245, 247, 249, 1),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}