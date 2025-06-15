import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/Inventory/Inventory.dart';

class InventoryController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'inventory';

  Future<void> addInventory(Inventory inventory) async {
    try {
      final data = inventory.toMap();
      data['createdAt'] = FieldValue.serverTimestamp();
      await _firestore.collection(collectionName).add(data);
    } catch (e) {
      rethrow;
    }
  }

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

  Stream<List<Inventory>> streamInventoryByWorkshop(String workshopName) {
    return _firestore
        .collection(collectionName)
        .where('workshopName', isEqualTo: workshopName)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Inventory.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> deleteInventory(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateInventory(String id, Inventory inventory) async {
    try {
      final data = inventory.toMap();
      data.remove('createdAt');
      await _firestore.collection(collectionName).doc(id).update(data);
    } catch (e) {
      rethrow;
    }
  }

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
