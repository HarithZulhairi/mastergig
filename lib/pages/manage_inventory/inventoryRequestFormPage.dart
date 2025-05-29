// inventoryRequestFormPage.dart
import 'package:flutter/material.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'inventoryPage.dart';

class InventoryRequestFormPage extends StatefulWidget {
  const InventoryRequestFormPage({super.key});

  @override
  State<InventoryRequestFormPage> createState() => _InventoryRequestFormPageState();
}

class _InventoryRequestFormPageState extends State<InventoryRequestFormPage> {
  String selectedQuantity = '1';
  String myWorkshopName = '';

  final Map<String, String> itemDetails = {
    'workshopName': 'Kita Workshop',
    'inventoryName': 'Michelin Pilot Sport 4',
    'workshopAddress': '123 Jalan Industri, Kajang',
    'quantity': '10',
    'unitPrice': '250',
    'notes': 'Tyre size 225/45 R17',
    'category': 'Tyres',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ownerHeader(context),
      bottomNavigationBar: ownerFooter(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Request Inventory', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Workshop: ${itemDetails['workshopName']}'),
            Text('Inventory: ${itemDetails['inventoryName']}'),
            Text('Address: ${itemDetails['workshopAddress']}'),
            Text('Available Quantity: ${itemDetails['quantity']}'),
            Text('Unit Price: RM${itemDetails['unitPrice']}'),
            Text('Notes: ${itemDetails['notes']}'),
            Text('Category: ${itemDetails['category']}'),
            const Divider(height: 32),
            DropdownButtonFormField<String>(
              value: selectedQuantity,
              decoration: const InputDecoration(labelText: 'Quantity to Request'),
              items: List.generate(10, (index) => (index + 1).toString())
                  .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                  .toList(),
              onChanged: (val) => selectedQuantity = val!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Your Workshop Name'),
              onChanged: (val) => myWorkshopName = val,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request Sent')));
                  },
                  child: const Text('Request'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => InventoryPage()));
                  },
                  child: const Text('All List'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
