import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';

class InventoryRequestPage extends StatefulWidget {
  final String workshopName;

  const InventoryRequestPage({super.key, required this.workshopName});

  @override
  State<InventoryRequestPage> createState() => _InventoryRequestPageState();
}

class _InventoryRequestPageState extends State<InventoryRequestPage> {
  String viewMode = 'Requested To Me'; // Default view

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
                    DropdownMenuItem(
                      value: 'Requested To Me',
                      child: Text('Requested To Me'),
                    ),
                    DropdownMenuItem(
                      value: 'My Requests',
                      child: Text('My Requests'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        viewMode = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('inventory_requests')
                  .where(
                    viewMode == 'Requested To Me' ? 'toWorkshop' : 'fromWorkshop',
                    isEqualTo: widget.workshopName,
                  )
                  .snapshots(), // 🔄 Removed .orderBy to avoid Firestore index error
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text('No inventory requests found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final item = docs[index];
                    final data = item.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(
                          data['itemName'] ?? 'No Item Name',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('From: ${data['fromWorkshop'] ?? '-'}'),
                            Text('To: ${data['toWorkshop'] ?? '-'}'),
                            Text('Quantity: ${data['quantity'] ?? '-'}'),
                            Text('Status: ${data['status'] ?? 'Pending'}'),
                          ],
                        ),
                        trailing: viewMode == 'Requested To Me'
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: () {
                                      item.reference.update({'status': 'Accepted'});
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Request accepted')),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      item.reference.update({'status': 'Cancelled'});
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Request cancelled')),
                                      );
                                    },
                                  ),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
