import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:intl/intl.dart'; // Import intl package

class DashboardController extends GetxController {
  var totalSales = 0.0.obs; // Observable untuk total penjualan
  var totalTransactions = 0.obs; // Observable untuk jumlah transaksi

  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Firebase Authentication instance

  @override
  void onInit() {
    super.onInit();
    fetchSalesSummary();
  }

  Future<void> fetchSalesSummary() async {
    try {
      // Mendapatkan user ID dari Firebase Authentication
      String? userId = _auth.currentUser?.uid;

      if (userId == null) {
        print('User not logged in');
        return;
      }

      // Ambil data transaksi berdasarkan user ID
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('USERS')
          .doc(userId) // Gunakan user ID yang benar
          .collection('TRANSAKSI')
          .get();

      // Debugging: Print jumlah transaksi yang diambil
      print('Fetched ${snapshot.docs.length} transactions for user $userId');

      double totalSalesAmount = 0.0;
      int totalTransactionsCount = snapshot.docs.length;

      // Iterasi melalui setiap dokumen transaksi
      for (var doc in snapshot.docs) {
        print('Transaction ID: ${doc.id}');
        var products = doc['products']; // Ambil daftar produk dari dokumen

        if (products != null) {
          // Iterasi melalui produk untuk menghitung total penjualan
          for (var product in products) {
            print('Product: ${product['name']}, Price: ${product['price']}');
            totalSalesAmount += product['price'];
          }
        }
      }

      // Perbarui nilai observable
      totalSales.value = totalSalesAmount;
      totalTransactions.value = totalTransactionsCount;

      // Format total penjualan dalam Rp (Rupiah)
      var formatter = NumberFormat.currency(
        locale: 'id_ID', // Locale Indonesia
        symbol: 'Rp', // Simbol mata uang
        decimalDigits: 0, // Hilangkan angka desimal
      );
      print('Total Sales: ${formatter.format(totalSalesAmount)}');
      print('Total Transactions: $totalTransactionsCount');
    } catch (e) {
      print('Error fetching sales summary: $e');
    }
  }
}
