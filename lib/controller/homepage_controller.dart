import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uaspemob/views/login_view.dart';

class HomeController extends GetxController {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  var shoppingList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  firebase_auth.User? get currentUser => _auth.currentUser;

  @override
  void onReady() {
    super.onReady();
    fetchShoppingList();
  }

  Future<void> fetchShoppingList() async {
    if (_auth.currentUser != null) {
      isLoading.value = true; // Set loading state to true before data fetch
      try {
        final snapshot = await _db
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('shopping_list')
            .get();

        shoppingList.value = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'name': data['name'],
            'quantity': data['quantity'],
          };
        }).toList();
      } catch (e) {
        print("Error fetching shopping list: $e");
        Get.snackbar("Error", "Failed to fetch shopping list");
      } finally {
        // Stop loading after data is fetched or error occurs
        isLoading.value = false;
      }
    } else {
      // If no user is logged in, stop loading
      isLoading.value = false;
      shoppingList.value = [];
    }
  }

  // Add item to Firestore
  Future<void> addItem(
    BuildContext context, {
    required String name,
    required int quantity,
  }) async {
    if (currentUser == null) {
      Get.snackbar("Error", "User is not authenticated");
      return;
    }

    try {
      // Validasi input
      if (name.isEmpty || quantity <= 0) {
        Get.snackbar("Invalid Input", "Name and quantity must be valid.");
        return;
      }

      final entryData = {
        'name': name,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(), // Timestamps untuk urutan
      };

      // Mengakses koleksi shopping_list untuk user yang sedang login
      final shoppingCollection = _db
          .collection('users')
          .doc(currentUser!.uid)
          .collection('shopping_list');

      // Menambahkan data ke Firestore dan mendapatkan ID dokumen
      final newDoc = await shoppingCollection.add(entryData);

      // Menambahkan item baru ke dalam shoppingList di aplikasi
      shoppingList.insert(0, {'id': newDoc.id, ...entryData});

      // Show snackbar after success
      Get.snackbar("Success", "Data berhasil ditambahkan!");

      // Fetch the updated list to reflect the changes
      fetchShoppingList();
    } catch (e) {
      print("Error adding data entry: $e");
      Get.snackbar("Gagal", "Data gagal ditambahkan! Error: $e");
    }
  }

  // Delete item from Firestore
  Future<void> deleteItem(String itemId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _db
            .collection('users') // Koleksi users
            .doc(user.uid) // Gunakan UID pengguna
            .collection('shopping_list') // Subkoleksi shopping_list
            .doc(itemId) // ID item yang akan dihapus
            .delete();

        // Mengupdate daftar belanja setelah menghapus item
        fetchShoppingList();
      }
    } catch (e) {
      print("Error deleting item: $e");
    }
  }

  // Update item in Firestore
  Future<void> updateItem(
    BuildContext context, {
    required String entryId,
    required String name,
    required int quantity,
  }) async {
    if (currentUser == null) {
      Get.snackbar("Error", "User is not authenticated");
      return;
    }

    try {
      final entryData = {
        'name': name,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _db
          .collection('users')
          .doc(currentUser!.uid)
          .collection('shopping_list')
          .doc(entryId)
          .update(entryData);

      final index = shoppingList.indexWhere((entry) => entry['id'] == entryId);
      if (index != -1) {
        shoppingList[index] = {'id': entryId, ...entryData};
      }

      Get.snackbar("Berhasil", "Data berhasil diubah!");
    } catch (e) {
      print("Error updating data entry: $e");
      Get.snackbar("Gagal", "Data gagal diubah!");
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Menghapus status login
    Get.offAll(() => Login()); // Redirect ke halaman login
  }
}
