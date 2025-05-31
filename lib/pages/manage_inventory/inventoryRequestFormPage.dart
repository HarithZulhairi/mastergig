import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryRequestFormPage extends StatefulWidget {
  final DocumentSnapshot item;
  const InventoryRequestFormPage({super.key, required this.item});

  @override
  State<InventoryRequestFormPage> createState() => _InventoryRequestFormPageState();
}

class _InventoryRequestFormPageState extends State<InventoryRequestFormPage> {
  String quantity = '';
  String myWorkshopName = '';

  Future<void> sendRequest() async {
    await FirebaseFirestore.instance.collection('inventory_requests').add({
      'itemId': widget.item.id,
      'itemName': widget.item['inventoryName'],
      'toWorkshop': widget.item['workshopName'],
      'fromWorkshop': myWorkshopName,
      'quantity': int.tryParse(quantity) ?? 1,
      'status': 'Pending',
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(title: const Text('Request Inventory')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Inventory: ${item['inventoryName']}'),
            Text('Available: ${item['quantity']}'),
            const Divider(),
            TextField(
              decoration: const InputDecoration(labelText: 'Quantity to Request'),
              keyboardType: TextInputType.number,
              onChanged: (val) => quantity = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Your Workshop Name'),
              onChanged: (val) => myWorkshopName = val,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await sendRequest();
                Navigator.pop(context);
              },
              child: const Text('Send Request'),
            ),
          ],
        ),
      ),
    );
  }
}
