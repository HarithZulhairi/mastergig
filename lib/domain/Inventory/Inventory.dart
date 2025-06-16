import 'package:cloud_firestore/cloud_firestore.dart';

class Inventory {
  final String id;
  final String inventoryName;
  final String workshopName;
  final String workshopAddress;
  final String additionalNotes;
  final String category;
  final int quantity;
  final double unitPrice;
  final DateTime createdAt;

  Inventory({
    this.id = '',
    required this.inventoryName,
    required this.workshopName,
    required this.workshopAddress,
    required this.additionalNotes,
    required this.category,
    required this.quantity,
    required this.unitPrice,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'inventoryName': inventoryName,
      'workshopName': workshopName,
      'workshopAddress': workshopAddress,
      'additionalNotes': additionalNotes,
      'category': category,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'createdAt': Timestamp.fromDate(createdAt), // Store as Firestore Timestamp
    };
  }

  factory Inventory.fromMap(Map<String, dynamic> map, [String id = '']) {
    final createdAtField = map['createdAt'];
    DateTime createdAtValue;

    if (createdAtField is Timestamp) {
      createdAtValue = createdAtField.toDate();
    } else if (createdAtField is String) {
      createdAtValue = DateTime.tryParse(createdAtField) ?? DateTime.now();
    } else {
      createdAtValue = DateTime.now();
    }

    return Inventory(
      id: id,
      inventoryName: map['inventoryName'] ?? '',
      workshopName: map['workshopName'] ?? '',
      workshopAddress: map['workshopAddress'] ?? '',
      additionalNotes: map['additionalNotes'] ?? '',
      category: map['category'] ?? '',
      quantity: map['quantity'] ?? 0,
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
      createdAt: createdAtValue,
    );
  }
}
