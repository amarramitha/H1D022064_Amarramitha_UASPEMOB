import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cashier_controller.dart';
import '../controller/login_controller.dart';
import '../widgets/input_field.dart';
import '../widgets/sidebar.dart';
import '../models/product.dart';

class CashierView extends StatelessWidget {
  final CashierController cashierController = Get.put(CashierController());
  final LoginController loginController = Get.find<LoginController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kasir',
          style: TextStyle(
            fontFamily: 'Jakarta', // Use the Jakarta font family
            fontWeight:
                FontWeight.bold, // Optional: Adjust the font weight if needed
          ),
        ),
        backgroundColor:
            Colors.blue[50], // Set the AppBar background to a soft blue
        centerTitle: true, // Center the title
      ),
      drawer: Sidebar(),
      backgroundColor: Colors.blue[50], // Set the background color to blue
      body: Padding(
        padding: const EdgeInsets.all(16.0), // General padding around the body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Produk Input
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 16.0), // Adds space between input fields
              child: CustomInputField(
                label: 'Nama Produk',
                controller: nameController,
                keyboardType: TextInputType.text,
                enabled: !cashierController.transactionCompleted.value,
              ),
            ),

            // Harga Produk Input
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 16.0), // Adds space between input fields
              child: CustomInputField(
                label: 'Harga',
                controller: priceController,
                keyboardType: TextInputType.number,
                enabled: !cashierController.transactionCompleted.value,
              ),
            ),

            // Tambah Produk Button
            ElevatedButton.icon(
              onPressed: cashierController.transactionCompleted.value
                  ? null // Disable if transaction is complete
                  : () {
                      if (nameController.text.isNotEmpty &&
                          priceController.text.isNotEmpty) {
                        final price = double.tryParse(priceController.text);
                        if (price == null || price <= 0) {
                          Get.snackbar(
                            'Input Error',
                            'Harga produk harus valid dan lebih besar dari 0.',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        final product = Product(
                          id: '', // ID will be assigned by Firestore
                          name: nameController.text,
                          price: price,
                        );
                        cashierController.addProduct(product);
                        nameController.clear();
                        priceController.clear();
                      } else {
                        Get.snackbar(
                          'Input Error',
                          'Nama dan harga produk harus diisi.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Produk'),
            ),
            const SizedBox(height: 16),

            // Total Price Display
            Obx(
              () => Text(
                'Total Harga: Rp ${cashierController.totalPrice.value.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jakarta', // Use the Jakarta font family
                ),
              ),
            ),
            const Divider(),

            Expanded(
              child: Obx(
                () {
                  if (cashierController.transactionCompleted.value) {
                    return Center(
                      child: Text(
                        'Transaksi Selesai. Tidak ada produk yang ditampilkan.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontFamily: 'Jakarta', // Use the Jakarta font family
                        ),
                      ),
                    );
                  } else if (cashierController.products.isEmpty) {
                    return Center(
                      child: Text(
                        'Belum ada produk ditambahkan.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontFamily: 'Jakarta', // Use the Jakarta font family
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: cashierController.products.length,
                    itemBuilder: (context, index) {
                      final product = cashierController.products[index];
                      return ListTile(
                        leading: const Icon(Icons.shopping_bag),
                        title: Text(
                          product.name,
                          style: TextStyle(
                              fontFamily:
                                  'Jakarta'), // Use the Jakarta font family
                        ),
                        subtitle: Text(
                          'Rp ${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontFamily:
                                  'Jakarta'), // Use the Jakarta font family
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const Divider(),

            // Complete Transaction Button
            ElevatedButton.icon(
              onPressed: cashierController.transactionCompleted.value
                  ? null // Disable if transaction is already complete
                  : () {
                      cashierController.completeTransaction();
                    },
              icon: const Icon(Icons.check),
              label: const Text(
                'Selesaikan Transaksi',
                style:
                    TextStyle(color: Colors.black), // Set text color to black
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[100], // Set background color
                foregroundColor:
                    Colors.black, // This also ensures the icon color is black
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
