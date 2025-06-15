import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'package:mastergig_app/pages/manage_inventory/inventoryPage.dart';

class InventoryRequestPage extends StatefulWidget {
  final String workshopName;

  const InventoryRequestPage({super.key, required this.workshopName});

  @override
  State<InventoryRequestPage> createState() => _InventoryRequestPageState();
}

class _InventoryRequestPageState extends State<InventoryRequestPage> {
  String viewMode = 'Requested To Me';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ownerHeader(context),
      bottomNavigationBar: ownerFooter(context),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    viewMode == 'Requested To Me'
                        ? 'Inventory Requests: ${widget.workshopName}'
                        : 'My Requests: ${widget.workshopName}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: viewMode,
                  items: const [
                    DropdownMenuItem(value: 'Requested To Me', child: Text('Requested To Me')),
                    DropdownMenuItem(value: 'My Requests', child: Text('My Requests')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => viewMode = value);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: viewMode == 'Requested To Me'
                  ? FirebaseFirestore.instance
                      .collection('inventory_requests')
                      .where('toWorkshop', isEqualTo: widget.workshopName)
                      .where('status', isEqualTo: 'Pending')
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('inventory_requests')
                      .where('fromWorkshop', isEqualTo: widget.workshopName)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final docs = snapshot.data!.docs;

                return Column(
                  children: [
                    Expanded(
                      child: docs.isEmpty
                          ? const Center(child: Text('No inventory requests found.'))
                          : ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: docs.length,
                              itemBuilder: (context, index) {
                                final item = docs[index];
                                final data = item.data() as Map<String, dynamic>;

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Left content
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data['itemName'] ?? 'No Item Name',
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(viewMode == 'Requested To Me'
                                                  ? 'From: ${data['fromWorkshop'] ?? '-'}'
                                                  : 'To: ${data['toWorkshop'] ?? '-'}'),
                                              Text('Quantity: ${data['quantity'] ?? '-'}'),
                                              Text('Status: ${data['status'] ?? 'Pending'}'),
                                            ],
                                          ),
                                        ),

                                        // Right-side buttons
                                        if (viewMode == 'Requested To Me') ...[
                                          Column(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await item.reference.update({'status': 'Accepted'});
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Request accepted')),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFFFFEB3B),
                                                  foregroundColor: Colors.black,
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                    side: const BorderSide(color: Colors.black),
                                                  ),
                                                ),
                                                child: const Text('Accept'),
                                              ),
                                              const SizedBox(height: 8),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await item.reference.update({'status': 'Cancelled'});
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Request cancelled')),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFFFFC107),
                                                  foregroundColor: Colors.black,
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                    side: const BorderSide(color: Colors.black),
                                                  ),
                                                ),
                                                child: const Text('Cancel'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

                    // Footer button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const InventoryPage()),
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
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}