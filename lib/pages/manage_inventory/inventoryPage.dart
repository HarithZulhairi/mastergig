import 'package:flutter/material.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/domain/Inventory/Inventory.dart';
import 'package:mastergig_app/provider/InventoryController.dart';
import 'package:mastergig_app/pages/manage_inventory/inventoryAddFormPage.dart';
import 'package:mastergig_app/pages/manage_inventory/inventoryRequestPage.dart'; // Create this page

class InventoryPage extends StatelessWidget {
  final InventoryController _inventoryController = InventoryController();

  void _showInventoryDetails(BuildContext context, Inventory item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Workshop: ${item.shopName}'),
            Text('Address: ${item.supplier}'),
            Text('Quantity: ${item.quantity} Units'),
            Text('Unit Price: RM${item.unitPrice.toStringAsFixed(2)}'),
            Text('Category: ${item.category}'),
            Text('Notes: ${item.notes}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ownerHeader(context),
      bottomNavigationBar: ownerFooter(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('List of Inventory', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // 🔵 Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Inventory'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const InventoryAddFormPage()));
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.inventory),
                  label: const Text('My List'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    // You are already on InventoryPage, so no need to push again.
                    // Maybe refresh in future
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Requests'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const InventoryRequestPage()));

                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 🔵 Inventory List
            Expanded(
              child: FutureBuilder<List<Inventory>>(
                future: _inventoryController.getInventoryList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No inventory available.'));
                  }

                  final inventoryList = snapshot.data!;
                  return ListView.builder(
                    itemCount: inventoryList.length,
                    itemBuilder: (context, index) {
                      final item = inventoryList[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(item.shopName),
                              Text('${item.quantity} Units'),
                              Text(item.notes),
                              Text(item.category),
                              Text('RM${item.unitPrice.toStringAsFixed(0)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () => _showInventoryDetails(context, item),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.yellow[700],
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  child: const Text('Request'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
