import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'inventoryPage.dart';

class InventoryAddFormPage extends StatefulWidget {
  const InventoryAddFormPage({super.key});

  @override
  State<InventoryAddFormPage> createState() => _InventoryAddFormPageState();
}

class _InventoryAddFormPageState extends State<InventoryAddFormPage> {
  final _formKey = GlobalKey<FormState>();
  String workshopName = '';
  String inventoryName = '';
  String workshopAddress = '';
  String quantity = '';
  String unitPrice = '';
  String notes = '';
  String category = '';

  Future<void> addInventory() async {
    try {
      await FirebaseFirestore.instance.collection('inventory').add({
        'inventoryName': inventoryName,
        'workshopName': workshopName,
        'workshopAddress': workshopAddress,
        'quantity': int.tryParse(quantity) ?? 0,
        'unitPrice': double.tryParse(unitPrice) ?? 0.0,
        'notes': notes,
        'category': category,
        'createdAt': Timestamp.now(),
      });
      print('Inventory added');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Inventory')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Workshop Name'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
                onChanged: (val) => workshopName = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Inventory Name'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
                onChanged: (val) => inventoryName = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Workshop Address'),
                onChanged: (val) => workshopAddress = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Required' : null,
                onChanged: (val) => quantity = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Unit Price (RM)'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Required' : null,
                onChanged: (val) => unitPrice = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
                onChanged: (val) => notes = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
                onChanged: (val) => category = val,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await addInventory();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const InventoryPage()),
                    );
                  }
                },
                child: const Text('Add Inventory'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
