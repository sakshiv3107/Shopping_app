import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatefulWidget {
  final String? productId;
  final Map<String, dynamic>? productData;

  const AddProductPage({super.key, this.productId, this.productData});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final titleCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final imageCtrl = TextEditingController();

  List<int> sizes = [];
  final sizeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    //EDIT MODE: prefill fields
    if (widget.productData != null) {
      titleCtrl.text = widget.productData!['title'] ?? '';
      priceCtrl.text =
          (widget.productData!['price'] ?? '').toString();
      companyCtrl.text = widget.productData!['company'] ?? '';
      imageCtrl.text = widget.productData!['image'] ?? '';

      sizes = List<int>.from(widget.productData!['sizes'] ?? []);
    }
  }

  bool validate() {
    if (titleCtrl.text.isEmpty ||
        priceCtrl.text.isEmpty ||
        companyCtrl.text.isEmpty ||
        imageCtrl.text.isEmpty ||
        sizes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields required")),
      );
      return false;
    }
    return true;
  }

  Future<void> saveProduct() async {
    if (!validate()) return;

    final data = {
      'title': titleCtrl.text.trim(),
      'price': double.tryParse(priceCtrl.text) ?? 0,
      'company': companyCtrl.text.trim(),
      'image': imageCtrl.text.trim(),
      'sizes': sizes,
    };

    if (widget.productId == null) {
      // ADD NEW
      await FirebaseFirestore.instance
          .collection('products')
          .add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product Added")),
      );
    } else {
      // UPDATE EXISTING
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .update(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product Updated")),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.productId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Product" : "Add Product"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Title"),
            ),

            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: companyCtrl,
              decoration: const InputDecoration(labelText: "Company"),
            ),

            TextField(
              controller: imageCtrl,
              decoration:
                  const InputDecoration(labelText: "Image Path"),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: sizeCtrl,
                    decoration:
                        const InputDecoration(labelText: "Add Size"),
                    keyboardType: TextInputType.number,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final s = int.tryParse(sizeCtrl.text);
                    if (s != null) {
                      setState(() {
                        sizes.add(s);
                        sizeCtrl.clear();
                      });
                    }
                  },
                )
              ],
            ),

            Wrap(
              spacing: 6,
              children: sizes
                  .map(
                    (s) => Chip(
                      label: Text(s.toString()),
                      onDeleted: () {
                        setState(() {
                          sizes.remove(s);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveProduct,
              child: Text(isEdit ? "Update Product" : "Save Product"),
            )
          ],
        ),
      ),
    );
  }
}
