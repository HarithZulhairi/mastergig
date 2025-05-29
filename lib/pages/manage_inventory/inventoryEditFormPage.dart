import 'package:flutter/material.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'package:mastergig_app/domain/Inventory/Inventory.dart';

class InventoryEditFormPage extends StatefulWidget {
  final Inventory existingItem;

  const InventoryEditFormPage({super.key, required this.existingItem});

  @override
  State<InventoryEditFormPage> createState() => _InventoryEditFormPageState();
}

class _InventoryEditFormPageState extends State<InventoryEditFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String supplier;
  late String notes;
  late String category;
  late String quantity;
  late String unitPrice;

  @override
  void initState() {
    super.initState();
    name = widget.existingItem.name;
    supplier = widget.existingItem.supplier;
    notes = widget.existingItem.notes;
    category = widget.existingItem.category;
    quantity = widget.existingItem.quantity.toString();
    unitPrice = widget.existingItem.unitPrice.toStringAsFixed(2);
  }

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
              const Text('Edit Inventory', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Inventory Name'),
                onChanged: (val) => name = val,
              ),
              TextFormField(
                initialValue: supplier,
                decoration: const InputDecoration(labelText: 'Supplier'),
                onChanged: (val) => supplier = val,
              ),
              TextFormField(
                initialValue: notes,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
                onChanged: (val) => notes = val,
              ),
              TextFormField(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (val) => category = val,
              ),
              TextFormField(
                initialValue: quantity,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (val) => quantity = val,
              ),
              TextFormField(
                initialValue: unitPrice,
                decoration: const InputDecoration(labelText: 'Unit Price (RM)'),
                keyboardType: TextInputType.number,
                onChanged: (val) => unitPrice = val,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedInventory = Inventory(
                      name: name,
                      supplier: supplier,
                      notes: notes,
                      category: category,
                      quantity: int.tryParse(quantity) ?? 0,
                      unitPrice: double.tryParse(unitPrice) ?? 0.0,
                    );
                    Navigator.pop(context, updatedInventory);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
