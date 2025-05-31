import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryEditFormPage extends StatefulWidget {
  final DocumentSnapshot item;

  const InventoryEditFormPage({super.key, required this.item});

  @override
  State<InventoryEditFormPage> createState() => _InventoryEditFormPageState();
}

class _InventoryEditFormPageState extends State<InventoryEditFormPage> {
  late TextEditingController nameCtrl, qtyCtrl, priceCtrl, noteCtrl, categoryCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.item['inventoryName']);
    qtyCtrl = TextEditingController(text: widget.item['quantity'].toString());
    priceCtrl = TextEditingController(text: widget.item['unitPrice'].toString());
    noteCtrl = TextEditingController(text: widget.item['notes']);
    categoryCtrl = TextEditingController(text: widget.item['category']);
  }

  Future<void> updateItem() async {
    await widget.item.reference.update({
      'inventoryName': nameCtrl.text,
      'quantity': int.tryParse(qtyCtrl.text) ?? 0,
      'unitPrice': double.tryParse(priceCtrl.text) ?? 0.0,
      'notes': noteCtrl.text,
      'category': categoryCtrl.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Inventory')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'Quantity')),
            TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Price')),
            TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: 'Notes')),
            TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: 'Category')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await updateItem();
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
