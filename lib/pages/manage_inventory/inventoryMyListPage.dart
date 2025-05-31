import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'inventoryEditFormPage.dart';

class InventoryMyListPage extends StatefulWidget {
  const InventoryMyListPage({super.key});

  @override
  State<InventoryMyListPage> createState() => _InventoryMyListPageState();
}

class _InventoryMyListPageState extends State<InventoryMyListPage> {
  String workshopName = '';
  bool hasSearched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Inventory List')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter your Workshop Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => workshopName = val.trim(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() => hasSearched = true);
              },
              child: const Text('Show My Inventory'),
            ),
            const SizedBox(height: 20),
            if (hasSearched)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('inventory')
                      .where('workshopName', isEqualTo: workshopName)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    final docs = snapshot.data!.docs;
                    if (docs.isEmpty) return const Text('No inventory found for this workshop.');
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final item = docs[index];
                        return ListTile(
                          title: Text(item['inventoryName']),
                          subtitle: Text('${item['quantity']} units | RM${item['unitPrice']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => InventoryEditFormPage(item: item),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await item.reference.delete();
                                },
                              ),
                            ],
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
