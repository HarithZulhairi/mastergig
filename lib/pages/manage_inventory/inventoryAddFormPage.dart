import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'package:mastergig_app/domain/Inventory/Inventory.dart';
import 'package:mastergig_app/provider/InventoryController.dart';

class InventoryAddFormPage extends StatefulWidget {
  const InventoryAddFormPage({super.key});

  @override
  State<InventoryAddFormPage> createState() => _InventoryAddFormPageState();
}

class _InventoryAddFormPageState extends State<InventoryAddFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _inventoryController = InventoryController();

  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _supplierController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _notesController = TextEditingController();
  final _categoryController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final newItem = Inventory(
      name: _nameController.text.trim(),
      quantity: int.parse(_quantityController.text.trim()),
      unitPrice: double.parse(_unitPriceController.text.trim()),
      supplier: _supplierController.text.trim(),
      shopName: _shopNameController.text.trim(),
      notes: _notesController.text.trim(),
      category: _categoryController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await _inventoryController.addInventory(newItem);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inventory added successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add inventory: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _supplierController.dispose();
    _shopNameController.dispose();
    _notesController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ownerHeader(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Add Inventory', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildTextField('Item Name', _nameController),
              _buildNumberField('Quantity', _quantityController),
              _buildNumberField('Unit Price (RM)', _unitPriceController),
              _buildTextField('Supplier', _supplierController),
              _buildTextField('Shop Name', _shopNameController),
              _buildTextField('Notes', _notesController, optional: true),
              _buildTextField('Category', _categoryController),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ownerFooter(context),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool optional = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (!optional && (value == null || value.isEmpty)) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          final numValue = double.tryParse(value);
          if (numValue == null || numValue < 0) return 'Enter valid number';
          return null;
        },
      ),
    );
  }
}
