import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/Inventory/Inventory.dart';

class InventoryController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'inventories';

  Future<void> addInventory(Inventory inventory) async {
    try {
      await _firestore.collection(collectionName).add(inventory.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Inventory>> getInventoryList() async {
    try {
      final snapshot = await _firestore.collection(collectionName).orderBy('createdAt', descending: true).get();
      return snapshot.docs.map((doc) => Inventory.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      rethrow;
    }
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
      await _firestore.collection(collectionName).doc(id).update(inventory.toMap());
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
