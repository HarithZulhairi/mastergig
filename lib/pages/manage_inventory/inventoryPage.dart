import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'inventoryAddFormPage.dart';
import 'inventoryMyListPage.dart';
import 'inventoryRequestFormPage.dart';
import 'inventoryRequestPage.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Inventory')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: const Text('Add Inventory'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryAddFormPage()));
                },
              ),
              ElevatedButton(
                child: const Text('My List'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryMyListPage()));
                },
              ),
              ElevatedButton(
                child: const Text('Requests'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryRequestPage()));
                },
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('inventory').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final items = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final data = items[index];
                    return ListTile(
                      title: Text(data['inventoryName']),
                      subtitle: Text('${data['category']} - ${data['quantity']} units'),
                      trailing: ElevatedButton(
                        child: const Text('Request'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InventoryRequestFormPage(item: data),
                            ),
                          );
                        },
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
