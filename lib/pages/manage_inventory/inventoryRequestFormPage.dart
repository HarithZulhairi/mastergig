import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';

class InventoryRequestFormPage extends StatefulWidget {
  final DocumentSnapshot item;
  const InventoryRequestFormPage({super.key, required this.item});

  @override
  State<InventoryRequestFormPage> createState() => _InventoryRequestFormPageState();
}

class _InventoryRequestFormPageState extends State<InventoryRequestFormPage> {
  final TextEditingController myWorkshopNameController = TextEditingController();
  String? selectedQuantity;

  Future<void> sendRequest() async {
    await FirebaseFirestore.instance.collection('inventory_requests').add({
      'itemId': widget.item.id,
      'itemName': widget.item['inventoryName'],
      'toWorkshop': widget.item['workshopName'],
      'fromWorkshop': myWorkshopNameController.text,
      'quantity': int.parse(selectedQuantity ?? '1'),
      'status': 'Pending',
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.item.data() as Map<String, dynamic>;
    final int maxQty = (data['quantity'] ?? 0) as int;

    return Scaffold(
      appBar: ownerHeader(context),
      bottomNavigationBar: ownerFooter(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Center(
              child: Text('Request Inventory', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            _buildLabel('Inventory Name'),
            _buildReadOnlyField(data['inventoryName'] ?? 'N/A'),

            const SizedBox(height: 15),
            _buildLabel('Available Quantity'),
            _buildReadOnlyField(maxQty.toString()),

            const SizedBox(height: 15),
            _buildLabel('Quantity to Request'),
            DropdownButtonFormField<String>(
              value: selectedQuantity,
              items: List.generate(maxQty, (index) {
                final value = (index + 1).toString();
                return DropdownMenuItem(value: value, child: Text(value));
              }),
              onChanged: (val) => setState(() => selectedQuantity = val),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),
            _buildLabel('Your Workshop Name'),
            TextFormField(
              controller: myWorkshopNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your workshop name',
              ),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedQuantity != null && myWorkshopNameController.text.isNotEmpty) {
                    await sendRequest();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Request submitted")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please complete all fields")));
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
                child: const Text('Send Request', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildReadOnlyField(String value) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }

  @override
  void dispose() {
    myWorkshopNameController.dispose();
    super.dispose();
  }
}