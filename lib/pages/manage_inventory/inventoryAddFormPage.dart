import 'package:flutter/material.dart';
import 'package:mastergig_app/domain/Inventory/Inventory.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'inventoryPage.dart'; // For navigation to All List

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ownerHeader(context),
      bottomNavigationBar: ownerFooter(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Inventory', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Workshop Name'),
                onChanged: (val) => workshopName = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Inventory Name'),
                onChanged: (val) => inventoryName = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Workshop Address'),
                onChanged: (val) => workshopAddress = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (val) => quantity = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Unit Price (RM)'),
                keyboardType: TextInputType.number,
                onChanged: (val) => unitPrice = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Additional Notes'),
                maxLines: 2,
                onChanged: (val) => notes = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (val) => category = val,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newInventory = Inventory(
                          name: inventoryName,
                          supplier: workshopName,
                          notes: notes,
                          category: category,
                          quantity: int.tryParse(quantity) ?? 0,
                          unitPrice: double.tryParse(unitPrice) ?? 0.0,
                          shopName: workshopName,
                          createdAt: DateTime.now(),
                        );
                        Navigator.pop(context, newInventory);
                      }
                    },
                    child: const Text('Add'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => InventoryPage()),
                      );
                    },
                    child: const Text('All List'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
