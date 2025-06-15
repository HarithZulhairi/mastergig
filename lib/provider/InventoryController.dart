import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/Inventory/Inventory.dart';

class InventoryController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'inventory';

  /// Add new inventory to Firestore
  Future<void> addInventory(Inventory inventory) async {
    try {
      final data = inventory.toMap();
      data['createdAt'] = FieldValue.serverTimestamp(); // Add timestamp
      await _firestore.collection(collectionName).add(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch all inventory items (latest first)
  Future<List<Inventory>> getInventoryList() async {
    try {
      final snapshot = await _firestore
          .collection(collectionName)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => Inventory.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Live stream inventory filtered by workshop name
  Stream<List<Inventory>> streamInventoryByWorkshop(String workshopName) {
    return _firestore
        .collection(collectionName)
        .where('workshopName', isEqualTo: workshopName)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Inventory.fromMap(doc.data(), doc.id)).toList());
  }

  /// Delete inventory item by ID
  Future<void> deleteInventory(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Update existing inventory item by ID
  Future<void> updateInventory(String id, Inventory inventory) async {
    try {
      final data = inventory.toMap();
      data.remove('createdAt'); // Don't overwrite the original timestamp
      await _firestore.collection(collectionName).doc(id).update(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get a single inventory item by ID
  Future<Inventory> getInventoryById(String id) async {
    try {
      final doc = await _firestore.collection(collectionName).doc(id).get();
      if (doc.exists) {
        return Inventory.fromMap(doc.data()!, doc.id);
      } else {
        throw Exception('Inventory not found');
      }
    } catch (e) {
      rethrow;
    }
  }
}
