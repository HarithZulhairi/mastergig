import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryRequestPage extends StatefulWidget {
  const InventoryRequestPage({super.key});

  @override
  State<InventoryRequestPage> createState() => _InventoryRequestPageState();
}

class _InventoryRequestPageState extends State<InventoryRequestPage> {
  String _selectedView = 'Requested to Me';
  String _workshopName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Requests')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Your Workshop Name'),
              onChanged: (val) => _workshopName = val.trim(),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedView,
              onChanged: (val) => setState(() => _selectedView = val!),
              items: const [
                DropdownMenuItem(value: 'Requested to Me', child: Text('Requested to Me')),
                DropdownMenuItem(value: 'My Request', child: Text('My Request')),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('inventory_requests')
                    .where(_selectedView == 'Requested to Me' ? 'toWorkshop' : 'fromWorkshop', isEqualTo: _workshopName)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) return const Text('No requests found.');
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final r = docs[index];
                      return Card(
                        child: ListTile(
                          title: Text('${r['itemName']} (${r['quantity']} units)'),
                          subtitle: Text('From: ${r['fromWorkshop']} | To: ${r['toWorkshop']}'),
                          trailing: _selectedView == 'Requested to Me'
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      onPressed: () => r.reference.update({'status': 'Accepted'}),
                                      child: const Text('Accept'),
                                    ),
                                    TextButton(
                                      onPressed: () => r.reference.update({'status': 'Cancelled'}),
                                      child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                )
                              : Text('Status: ${r['status']}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
