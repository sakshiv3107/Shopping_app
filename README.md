# 🛍 Shopping App – Flutter + Firebase

A mobile shopping application with real-time product listing, cart management, checkout, and order history using **Flutter & Firebase**.

## Features

* 🔐 Firebase Authentication (Login/Signup/Logout)
* 🏬 Real-time products from Firestore
* 🔍 Search & filter by brand
* 🛒 Add to cart with quantity & size management
* 💳 Checkout with address & payment method
* 📦 Order placement & order history

## Tech Stack

* Flutter (Dart)
* Firebase Authentication
* Cloud Firestore

## Firestore Structure

* `users/{uid}/cart/{productId}`
* `orders/{orderId}` → items, totalPrice, address, paymentMethod, status, createdAt

## Setup

```bash
flutter pub get
flutter run
```

**Developed by: Sakshi**
