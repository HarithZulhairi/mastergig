import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'package:mastergig_app/pages/manage_inventory/inventoryAddFormPage.dart';
import 'package:mastergig_app/pages/manage_inventory/inventoryRequestPage.dart';
import 'package:mastergig_app/pages/manage_inventory/inventoryMyListPage.dart';
import 'package:mastergig_app/pages/manage_inventory/inventoryRequestFormPage.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ownerHeader(context),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final snapshot = await FirebaseFirestore.instance
                          .collection('inventory')
                          .orderBy('createdAt', descending: true)
                          .limit(1)
                          .get();
                      if (snapshot.docs.isNotEmpty) {
                        final workshopName = snapshot.docs.first['workshopName'] ?? 'Unknown';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InventoryRequestPage(workshopName: workshopName),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("No inventory available to get workshop name")),
                        );
                      }
                    },
                    style: _buttonStyle(),
                    child: const Text('Requests'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryAddFormPage()));
                    },
                    style: _buttonStyle(),
                    child: const Text('Add Inventory'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final snapshot = await FirebaseFirestore.instance
                          .collection('inventory')
                          .orderBy('createdAt', descending: true)
                          .limit(1)
                          .get();
                      if (snapshot.docs.isNotEmpty) {
                        final workshopName = snapshot.docs.first['workshopName'] ?? 'Unknown';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InventoryMyListPage(workshopName: workshopName),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("No inventory available to get workshop name")),
                        );
                      }
                    },
                    style: _buttonStyle(),
                    child: const Text('My List'),
                  ),
                ),
              ],
            ),
          ),
          ownerFooter(context),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'List of Inventory',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('inventory')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) return const Center(child: Text("No inventory items found."));

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final docSnapshot = docs[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(
                          data['inventoryName'] ?? 'No Name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18, // Bigger and bold
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Workshop: ${data['workshopName'] ?? 'N/A'}'),
                            Text('Address: ${data['workshopAddress'] ?? 'N/A'}'),
                            Text('Quantity: ${data['quantity'].toString()}'),
                            Text('Price: RM ${data['unitPrice'].toString()}'),
                            Text('Category: ${data['category'] ?? '-'}'),
                            Text('Notes: ${data['additionalNotes'] ?? '-'}'),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => InventoryRequestFormPage(item: docSnapshot),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(238, 239, 211, 11),
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
                              "Request",
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ),
                        isThreeLine: true,
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

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(238, 239, 211, 11),
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
        side: const BorderSide(color: Colors.black),
      ),
    );
  }
}