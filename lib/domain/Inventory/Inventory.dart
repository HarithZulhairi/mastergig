class Inventory {
  final String id;
  final String inventoryName;     // formerly 'name'
  final String workshopName;      // formerly 'supplier'
  final String workshopAddress;   // formerly 'shopName'
  final String additionalNotes;   // formerly 'notes'
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
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Inventory.fromMap(Map<String, dynamic> map, [String id = '']) {
    return Inventory(
      id: id,
      inventoryName: map['inventoryName'] ?? '',
      workshopName: map['workshopName'] ?? '',
      workshopAddress: map['workshopAddress'] ?? '',
      additionalNotes: map['additionalNotes'] ?? '',
      category: map['category'] ?? '',
      quantity: map['quantity'] ?? 0,
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
