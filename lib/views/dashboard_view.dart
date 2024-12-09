import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uaspemob/controller/dashboard_controller.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'package:fl_chart/fl_chart.dart'; // Import the fl_chart package
import '../widgets/sidebar.dart';

class DashboardView extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontFamily: 'Jakartamedium',
            fontWeight:
                FontWeight.bold, // Optional: Adjust the font weight if needed
          ),
        ),
        backgroundColor:
            Colors.blue[50], // Set the AppBar background to a soft blue
        centerTitle: true, // Center the title
      ),
      drawer: Sidebar(),
      body: Container(
        color: Colors.blue[50], // Soft blue background color
        width: double.infinity, // Make the container fill the screen width
        height: double.infinity, // Make the container fill the screen height
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Simple Line Chart to show sales and transactions data
              Obx(() {
                double totalSales = controller.totalSales.value.toDouble();
                double totalTransactions =
                    controller.totalTransactions.value.toDouble();
                double averageSale = totalTransactions > 0
                    ? totalSales / totalTransactions
                    : 0.0;

                // Check for invalid data before plotting
                if (totalSales.isNaN || totalTransactions.isNaN) {
                  return const Center(child: Text('Invalid Data for Chart'));
                }

                // Chart Data (Simple 2-point line chart)
                List<FlSpot> data = [
                  FlSpot(0, totalSales), // Total Sales
                  FlSpot(1, totalTransactions), // Total Transactions
                ];

                return Container(
                  height: 300, // Provide a height constraint for the chart
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(show: true),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, totalSales),
                            FlSpot(1, totalTransactions),
                          ],
                          isCurved: true,
                          color: Colors.blue,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: true), // Show dots on points
                        ),
                        // Add Average Sale Line
                        LineChartBarData(
                          spots: [
                            FlSpot(0, averageSale),
                            FlSpot(1, averageSale),
                          ],
                          isCurved: false,
                          color: Colors
                              .red, // Use a different color for the average line
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(
                              show: false), // Hide dots for the average line
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Card for displaying the summary
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text under chart
                      Obx(() {
                        var formatter = NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp',
                          decimalDigits: 0,
                        );
                        return Text(
                          'Total Penjualan: ${formatter.format(controller.totalSales.value)}',
                          style: TextStyle(
                            fontFamily: 'Jakarta', // Jakarta font
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      Obx(() {
                        return Text(
                          'Total Transaksi: ${controller.totalTransactions.value}',
                          style: TextStyle(
                            fontFamily: 'Jakarta',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      Obx(() {
                        double averageSale =
                            controller.totalTransactions.value > 0
                                ? controller.totalSales.value /
                                    controller.totalTransactions.value
                                : 0.0;
                        var formatter = NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp',
                          decimalDigits: 0,
                        );
                        return Text(
                          'Rata-Rata Penjualan: ${formatter.format(averageSale)}',
                          style: TextStyle(
                            fontFamily: 'Jakarta',
                            fontSize: 16,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
