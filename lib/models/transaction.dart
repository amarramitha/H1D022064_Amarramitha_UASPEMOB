import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure Timestamp is imported

class TransactionData {
  final double amount;
  final DateTime date;

  TransactionData({required this.amount, required this.date});

  // Factory constructor to create a TransactionData object from Firestore document data
  factory TransactionData.fromFirestore(Map<String, dynamic> doc) {
    return TransactionData(
      amount: doc['amount'] ?? 0.0,
      date: (doc['timestamp'] as Timestamp)
          .toDate(), // Convert Firestore Timestamp to DateTime
    );
  }

  // Method to convert the model to a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'timestamp':
          Timestamp.fromDate(date), // Convert DateTime to Firestore Timestamp
    };
  }
}
