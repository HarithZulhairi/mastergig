import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'package:mastergig_app/pages/manage_inventory/inventoryPage.dart';
import 'package:mastergig_app/provider/InventoryController.dart';
import 'package:mastergig_app/domain/Inventory/Inventory.dart';

class InventoryAddFormPage extends StatefulWidget {
  const InventoryAddFormPage({super.key});

  @override
  State<InventoryAddFormPage> createState() => _InventoryAddFormPageState();
}

class _InventoryAddFormPageState extends State<InventoryAddFormPage> {
  final InventoryController _controller = InventoryController();

  final TextEditingController workshopNameController = TextEditingController();
  final TextEditingController inventoryNameController = TextEditingController();
  final TextEditingController workshopAddressController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController additionalNotesController = TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ownerHeader(context),
      bottomNavigationBar: ownerFooter(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Add Inventory',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(workshopNameController, 'Workshop Name'),
            _buildTextField(inventoryNameController, 'Inventory Name'),
            _buildTextField(workshopAddressController, 'Workshop Address'),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    quantityController,
                    'Quantity',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    unitPriceController,
                    'Unit Price (RM)',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            _buildTextField(additionalNotesController, 'Additional Notes'),
            DropdownButtonFormField<String>(
              value: selectedCategory.isEmpty ? null : selectedCategory,
              items: categories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => selectedCategory = value ?? ''),
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Add Inventory Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final inventory = Inventory(
                      workshopName: workshopNameController.text,
                      inventoryName: inventoryNameController.text,
                      workshopAddress: workshopAddressController.text,
                      quantity: int.tryParse(quantityController.text) ?? 0,
                      unitPrice: double.tryParse(unitPriceController.text) ?? 0.0,
                      additionalNotes: additionalNotesController.text,
                      category: selectedCategory,
                    );

                    await _controller.addInventory(inventory);
                    Get.snackbar('Success', 'Inventory added!');
                    _clearFields();
                  } catch (e) {
                    Get.snackbar('Error', 'Failed to add inventory');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(238, 239, 211, 11),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
                child: const Text(
                  'Add Inventory',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // List of Inventory Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InventoryPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(238, 239, 211, 11),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
                child: const Text(
                  'List of Inventory',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _clearFields() {
    workshopNameController.clear();
    inventoryNameController.clear();
    workshopAddressController.clear();
    quantityController.clear();
    unitPriceController.clear();
    additionalNotesController.clear();
    setState(() {
      selectedCategory = '';
    });
  }

  @override
  void dispose() {
    workshopNameController.dispose();
    inventoryNameController.dispose();
    workshopAddressController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    additionalNotesController.dispose();
    super.dispose();
  }
}
