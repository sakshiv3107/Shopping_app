import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shopping_app/cart_provider.dart';
import 'package:shopping_app/models/product_model.dart';
// import 'package:shopping_app/cart_item.dart';
import 'package:shopping_app/services/cart_firestore_service.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int? selectedSize;
  final cartService = CartFirestoreService();

  void onTap() {
     cartService.addToCart(
      productId: widget.product.id,
      title: widget.product.title,
      price: widget.product.price,
      image: widget.product.imageUrl,
      size: selectedSize.toString(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added to cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Details'), centerTitle: true),
      body: Column(
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              widget.product.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          const SizedBox(height: 20),

          // Product Image
          Expanded(
            child: Image.asset(widget.product.imageUrl, fit: BoxFit.contain),
          ),

          //  Bottom Sheet
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(245, 247, 249, 1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price
                Text(
                  '\$${widget.product.price}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 16),

                //  Size title
                const Text(
                  'Select Size',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 10),

                // Sizes
                SizedBox(
                  height: 45,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: (widget.product.sizes).length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final size = (widget.product.sizes)[index];
                      final isSelected = selectedSize == size;

                      return ChoiceChip(
                        label: Text(size.toString()),
                        selected: isSelected,
                        showCheckmark: false,
                        selectedColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : Colors.grey.shade700,
                        ),
                        onSelected: (_) {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Add to Cart Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: selectedSize == null ? null : onTap,
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
