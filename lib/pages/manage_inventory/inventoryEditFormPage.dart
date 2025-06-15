import 'package:flutter/material.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'package:mastergig_app/domain/Inventory/Inventory.dart';
import 'package:mastergig_app/provider/InventoryController.dart';
import 'package:mastergig_app/pages/manage_inventory/inventoryMyListPage.dart';

class InventoryEditFormPage extends StatefulWidget {
  final Inventory item;

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
  final InventoryController _controller = InventoryController();

  late String docId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    docId = widget.item.id;

    nameCtrl = TextEditingController(text: widget.item.inventoryName);
    qtyCtrl = TextEditingController(text: widget.item.quantity.toString());
    priceCtrl = TextEditingController(text: widget.item.unitPrice.toString());
    noteCtrl = TextEditingController(text: widget.item.additionalNotes);
    selectedCategory = widget.item.category;
    workshopAddressCtrl = TextEditingController(text: widget.item.workshopAddress);
    workshopNameCtrl = TextEditingController(text: widget.item.workshopName);
  }

  Future<void> _submitForm() async {
    setState(() => _isSubmitting = true);

    final inventory = Inventory(
      id: docId,
      inventoryName: nameCtrl.text,
      quantity: int.tryParse(qtyCtrl.text) ?? 0,
      unitPrice: double.tryParse(priceCtrl.text) ?? 0.0,
      additionalNotes: noteCtrl.text,
      category: selectedCategory,
      workshopAddress: workshopAddressCtrl.text,
      workshopName: workshopNameCtrl.text,
      createdAt: widget.item.createdAt, // retain original creation date
    );

    await _controller.updateInventory(docId, inventory);

    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.pop(context);
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
                  child: _buildTextField(
                    qtyCtrl,
                    'Quantity',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    priceCtrl,
                    'Unit Price (RM)',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            _buildTextField(noteCtrl, 'Additional Notes'),
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

            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9BE08),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 0.5,
                    ),
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Back Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InventoryMyListPage(
                        workshopName: workshopNameCtrl.text,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9BE08),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 0.5,
                    ),
                  ),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
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
