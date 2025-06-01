import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';

class InventoryEditFormPage extends StatefulWidget {
  final DocumentSnapshot item;

  const InventoryEditFormPage({super.key, required this.item});

  @override
  State<InventoryEditFormPage> createState() => _InventoryEditFormPageState();
}

class _InventoryEditFormPageState extends State<InventoryEditFormPage> {
  late TextEditingController nameCtrl;
  late TextEditingController qtyCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController noteCtrl;
  late TextEditingController workshopAddressCtrl;
  late TextEditingController workshopNameCtrl;

  final List<String> categories = [
    'Tools & Equipment',
    'Engine & Mechanical Parts',
    'Electrical Components',
    'Fluids & Lubricants',
    'Tyres & Wheels',
    'Body & Interior Parts',
    'Consumables & Fasteners',
    'Safety & Cleaning Supplies',
  ];

  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    final data = widget.item.data() as Map<String, dynamic>;

    nameCtrl = TextEditingController(text: data['inventoryName'] ?? '');
    qtyCtrl = TextEditingController(text: data['quantity'].toString());
    priceCtrl = TextEditingController(text: data['unitPrice'].toString());
    noteCtrl = TextEditingController(text: data['additionalNotes'] ?? '');
    selectedCategory = data['category'] ?? '';
    workshopAddressCtrl = TextEditingController(text: data['workshopAddress'] ?? '');
    workshopNameCtrl = TextEditingController(text: data['workshopName'] ?? '');
  }

  Future<void> updateItem() async {
    await widget.item.reference.update({
      'inventoryName': nameCtrl.text,
      'quantity': int.tryParse(qtyCtrl.text) ?? 0,
      'unitPrice': double.tryParse(priceCtrl.text) ?? 0.0,
      'additionalNotes': noteCtrl.text,
      'category': selectedCategory,
      'workshopAddress': workshopAddressCtrl.text,
      'workshopName': workshopNameCtrl.text,
    });
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ownerHeader(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Edit Inventory',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(workshopNameCtrl, 'Workshop Name'),
            _buildTextField(nameCtrl, 'Inventory Name'),
            _buildTextField(workshopAddressCtrl, 'Workshop Address'),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(qtyCtrl, 'Quantity', keyboardType: TextInputType.number)),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildTextField(priceCtrl, 'Unit Price (RM)', keyboardType: TextInputType.number)),
              ],
            ),
            _buildTextField(noteCtrl, 'Additional Notes'),
            DropdownButtonFormField<String>(
              value: selectedCategory.isEmpty ? null : selectedCategory,
              items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) => setState(() => selectedCategory = value ?? ''),
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await updateItem();
                  if (context.mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
                child: const Text('Update', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ownerFooter(context),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    qtyCtrl.dispose();
    priceCtrl.dispose();
    noteCtrl.dispose();
    workshopAddressCtrl.dispose();
    workshopNameCtrl.dispose();
    super.dispose();
  }
}
