class Inventory {
  final String id;
  final String name;
  final int quantity;
  final double unitPrice;
  final String supplier;
  final String shopName;
  final String notes;
  final String category;
  final DateTime createdAt;

  Inventory({
    this.id = '',
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.supplier,
    required this.shopName,
    required this.notes,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'supplier': supplier,
      'shopName': shopName,
      'notes': notes,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Inventory.fromMap(Map<String, dynamic> map, [String id = '']) {
    return Inventory(
      id: id,
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      unitPrice: (map['unitPrice'] as num).toDouble(),
      supplier: map['supplier'] ?? '',
      shopName: map['shopName'] ?? '',
      notes: map['notes'] ?? '',
      category: map['category'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
