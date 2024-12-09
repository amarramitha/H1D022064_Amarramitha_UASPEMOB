import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import 'package:flutter/material.dart';

class CashierController extends GetxController {
  // Observable variables to track state
  var totalAmount = 0.0.obs;
  var products = <Product>[].obs;
  var transactionCompleted = false.obs; // To track transaction state
  var currentTransactionId = ''.obs; // Track the current transaction ID

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Load products from Firestore on controller initialization
  @override
  void onInit() {
    super.onInit();
    loadActiveTransaction(); // Load active transaction when the controller initializes
  }

  Future<void> loadActiveTransaction() async {
    try {
      String userId = _auth.currentUser!.uid;
      // Query untuk transaksi yang belum selesai
      QuerySnapshot snapshot = await _firestore
          .collection('USERS')
          .doc(userId)
          .collection('TRANSAKSI')
          .where('completed', isEqualTo: false)
          .get();

      if (snapshot.docs.isEmpty) {
        // Tidak ada transaksi aktif, mulai transaksi baru
        startNewTransaction();
      } else {
        // Ada transaksi aktif, muat transaksi pertama
        var doc = snapshot.docs.first;
        currentTransactionId.value = doc.id;
        var productList = doc['products'] ?? [];

        // Pemetaan data produk menjadi objek Product
        products.assignAll(
            productList.map<Product>((item) => Product.fromMap(item)));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load active transaction: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Function to start a new transaction
  Future<void> startNewTransaction() async {
    try {
      String userId = _auth.currentUser!.uid;
      // Start a new transaction with an empty products list
      DocumentReference newTransactionRef = await _firestore
          .collection('USERS')
          .doc(userId)
          .collection('TRANSAKSI')
          .add({
        'completed': false,
        'products': [],
        'timestamp': FieldValue.serverTimestamp(),
      });

      currentTransactionId.value = newTransactionRef.id;
      products.clear(); // Clear the current products list
      totalAmount.value = 0.0; // Reset total amount to 0
    } catch (e) {
      // Removed the snackbar notification as per your request
      // Handle error silently
    }
  }

  // Function to add a product to the current transaction
  Future<void> addProduct(Product product) async {
    try {
      if (currentTransactionId.value.isEmpty) {
        // No active transaction, start a new one
        startNewTransaction();
      }

      String userId = _auth.currentUser!.uid;
      DocumentReference transactionRef = _firestore
          .collection('USERS')
          .doc(userId)
          .collection('TRANSAKSI')
          .doc(currentTransactionId.value);

      // Add product to Firestore within the current transaction
      await transactionRef.update({
        'products': FieldValue.arrayUnion([product.toMap()])
      });

      // Update the local list of products
      products.add(product);
    } catch (e) {
      // Handle error silently without snackbar notification
    }
  }

  // Function to complete the transaction
  // Function to complete the transaction
  void completeTransaction() async {
    if (products.isNotEmpty) {
      try {
        String userId = _auth.currentUser!.uid;
        DocumentReference transactionRef = _firestore
            .collection('USERS')
            .doc(userId)
            .collection('TRANSAKSI')
            .doc(currentTransactionId.value);

        // Mark the transaction as completed
        await transactionRef.update({'completed': true});

        // Clear the current transaction
        transactionCompleted.value = true;
        products.clear(); // Clear the local product list
        totalAmount.value = 0.0; // Reset the total amount

        // Start a new transaction after completing the current one
        startNewTransaction();

        // Reload the active transaction to ensure UI is updated
        loadActiveTransaction();

        Get.snackbar(
          'Transaksi Berhasil',
          'Transaksi Berhasil Ditambahkan!',
        );
      } catch (e) {
        Get.snackbar(
          'Gagal',
          'Gagal Menambahkan Transaksi: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'There are no products to complete the transaction.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Function to reset the cashier view for a new transaction
  void resetTransaction() {
    transactionCompleted.value = false;
    products.clear();
    totalAmount.value = 0.0; // Reset the total price to 0.0
    startNewTransaction(); // Start a new transaction
  }

  // Getter to calculate totalAmount
  RxDouble get totalPrice => RxDouble(
        products.fold(0.0, (sum, item) => sum + item.price),
      );
}
