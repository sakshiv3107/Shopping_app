import 'package:flutter/material.dart';
import 'cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // ➕ Add product
  void addProduct(CartItem newItem) {
    final index = _items.indexWhere(
      (item) => item.id == newItem.id && item.size == newItem.size,
    );

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  // ❌ Remove product completely
  void removeProduct(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  // ➕ Increase quantity
  void increaseQty(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  // ➖ Decrease quantity
  void decreaseQty(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  // 💲 Total price
  double get totalPrice {
    return _items.fold(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );
  }
}
