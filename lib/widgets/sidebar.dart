import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color:
            Colors.blue[50], // Set the background color of the entire sidebar
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 133, 200, 254),
              ),
              child: Center(
                child: Text(
                  'POS',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Jakartamedium',
                      fontSize: 20),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard), // Icon for Dashboard
              title: const Text(
                'Dashboard',
                style: TextStyle(fontFamily: 'Jakarta'), // Set font to Jakarta
              ),
              onTap: () => Get.offNamed('/dashboard'),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart), // Icon for Kasir
              title: const Text(
                'Kasir',
                style: TextStyle(fontFamily: 'Jakarta'), // Set font to Jakarta
              ),
              onTap: () => Get.offNamed('/cashier'),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app), // Icon for Logout
              title: const Text(
                'Logout',
                style: TextStyle(fontFamily: 'Jakarta'), // Set font to Jakarta
              ),
              onTap: () => Get.offAllNamed('/login'),
            ),
          ],
        ),
      ),
    );
  }
}
