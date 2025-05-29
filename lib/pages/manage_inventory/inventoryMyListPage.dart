import 'package:flutter/material.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'inventoryEditFormPage.dart';
import 'inventoryAddFormPage.dart';
import 'package:mastergig_app/domain/Inventory/Inventory.dart';

class InventoryMyListPage extends StatefulWidget {
  const InventoryMyListPage({super.key});

  @override
  State<InventoryMyListPage> createState() => _InventoryMyListPageState();
}

class _InventoryMyListPageState extends State<InventoryMyListPage> {
  final List<Inventory> myItems = [];

  void _deleteItem(int index) {
    setState(() {
      myItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item deleted')),
    );
  }

  void _editItem(int index, Inventory updatedItem) {
    setState(() {
      myItems[index] = updatedItem;
    });
  }

  Future<void> _navigateToAddForm() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InventoryAddFormPage()),
    );

    if (newItem != null && newItem is Inventory) {
      setState(() {
        myItems.add(newItem);
      });
    }
  }

  Future<void> _navigateToEditForm(int index, Inventory currentItem) async {
    final updatedItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InventoryEditFormPage(existingItem: currentItem),
      ),
    );

    if (updatedItem != null && updatedItem is Inventory) {
      _editItem(index, updatedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ownerHeader(context),
      bottomNavigationBar: ownerFooter(context),
      body: myItems.isEmpty
          ? const Center(child: Text('No inventory added yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myItems.length,
              itemBuilder: (context, index) {
                final item = myItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Quantity: ${item.quantity}'),
                        Text('Supplier: ${item.supplier}'),
                        Text('Spec: ${item.notes}'),
                        Text('Category: ${item.category}'),
                        Text('Price: RM${item.unitPrice.toStringAsFixed(2)}'),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  _navigateToEditForm(index, item),
                              child: const Text('Edit'),
                            ),
                            TextButton(
                              onPressed: () => _deleteItem(index),
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddForm,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}
