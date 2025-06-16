import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/Inventory/Inventory.dart';

class InventoryController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'inventory';

  // --- INVENTORY MANAGEMENT METHODS ---

  Future<void> addInventory(Inventory inventory) async {
    try {
      final data = inventory.toMap();
      data['createdAt'] = FieldValue.serverTimestamp();
      await _firestore.collection(collectionName).add(data);
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

  Future<void> deleteInventory(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
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

  // --- HANDLE ADD/UPDATE FOR INVENTORY FORM ---

  Future<void> handleAddInventory({
    required BuildContext context,
    required String workshopName,
    required String inventoryName,
    required String workshopAddress,
    required String quantityText,
    required String unitPriceText,
    required String additionalNotes,
    required String category,
  }) async {
    try {
      final inventory = Inventory(
        workshopName: workshopName,
        inventoryName: inventoryName,
        workshopAddress: workshopAddress,
        quantity: int.tryParse(quantityText) ?? 0,
        unitPrice: double.tryParse(unitPriceText) ?? 0.0,
        additionalNotes: additionalNotes,
        category: category,
      );

      await addInventory(inventory);
      Get.snackbar('Success', 'Inventory added!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add inventory');
    }
  }

  Future<void> handleUpdateInventory({
    required BuildContext context,
    required Inventory item,
    required String inventoryName,
    required String workshopName,
    required String workshopAddress,
    required String quantityText,
    required String unitPriceText,
    required String additionalNotes,
    required String category,
  }) async {
    try {
      final updatedInventory = Inventory(
        id: item.id,
        inventoryName: inventoryName,
        workshopName: workshopName,
        workshopAddress: workshopAddress,
        quantity: int.tryParse(quantityText) ?? 0,
        unitPrice: double.tryParse(unitPriceText) ?? 0.0,
        additionalNotes: additionalNotes,
        category: category,
        createdAt: item.createdAt,
      );

      await updateInventory(item.id, updatedInventory);
      Get.snackbar('Success', 'Inventory updated!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update inventory');
    }
  }

  void showDeleteConfirmationDialog(BuildContext context, Inventory item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Confirm Delete',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          content: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Are you sure you want to delete this inventory?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          actionsPadding: const EdgeInsets.only(bottom: 20),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7878),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      child: const Text('No', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await deleteInventory(item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Item deleted')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1EEF0B),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      child: const Text('Yes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // --- INVENTORY REQUEST LOGIC ---

  Future<void> sendInventoryRequest({
    required String itemId,
    required String itemName,
    required String toWorkshop,
    required String fromWorkshop,
    required int quantity,
  }) async {
    try {
      await _firestore.collection('inventory_requests').add({
        'itemId': itemId,
        'itemName': itemName,
        'toWorkshop': toWorkshop,
        'fromWorkshop': fromWorkshop,
        'quantity': quantity,
        'status': 'Pending',
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getRequestStream(String workshopName, String viewMode) {
    final collection = _firestore.collection('inventory_requests');
    if (viewMode == 'Requested To Me') {
      return collection
          .where('toWorkshop', isEqualTo: workshopName)
          .where('status', isEqualTo: 'Pending')
          .snapshots();
    } else {
      return collection
          .where('fromWorkshop', isEqualTo: workshopName)
          .snapshots();
    }
  }

  Future<void> acceptRequest(String requestId) async {
    try {
      await _firestore.collection('inventory_requests').doc(requestId).update({'status': 'Accepted'});
      Get.snackbar('Request Accepted', 'The request has been accepted.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept request');
      rethrow;
    }
  }

  Future<void> cancelRequest(String requestId) async {
    try {
      await _firestore.collection('inventory_requests').doc(requestId).update({'status': 'Cancelled'});
      Get.snackbar('Request Cancelled', 'The request has been cancelled.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel request');
      rethrow;
    }
  }
}
