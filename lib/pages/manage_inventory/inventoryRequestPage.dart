import 'package:flutter/material.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/pages/manage_inventory/inventoryAddFormPage.dart';
import 'package:mastergig_app/pages/manage_inventory/inventoryPage.dart';
// import 'inventoryMyListPage.dart'; // Uncomment if "My List" page is implemented

class InventoryRequestPage extends StatefulWidget {
  const InventoryRequestPage({super.key});

  @override
  State<InventoryRequestPage> createState() => _InventoryRequestPageState();
}

class _InventoryRequestPageState extends State<InventoryRequestPage> {
  String _selectedView = 'Requested to Me';

  final List<Map<String, String>> requestedToMe = [
    {
      'item': 'Michelin Pilot Sport 4',
      'from': 'Kita Workshop',
      'quantity': '5',
    },
    {
      'item': 'Amaron Hi-Life 55B24L',
      'from': 'Lima Workshop',
      'quantity': '2',
    },
  ];

  final List<Map<String, String>> myRequests = [
    {
      'item': 'Michelin Pilot Sport 4',
      'to': 'Rizal Workshop',
      'quantity': '3',
      'status': 'Pending',
    },
    {
      'item': 'Amaron Hi-Life 55B24L',
      'to': 'Kita Workshop',
      'quantity': '2',
      'status': 'Accepted',
    },
  ];

  void _handleAccept(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Accepted request for ${requestedToMe[index]['item']}")),
    );
  }

  void _handleCancel(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Cancelled request for ${requestedToMe[index]['item']}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRequestedToMe = _selectedView == 'Requested to Me';

    return Scaffold(
      appBar: ownerHeader(context),
      bottomNavigationBar: ownerFooter(context), // Only this footer is kept
      body: Column(
        children: [
          const SizedBox(height: 16),
          Center(
            child: DropdownButton<String>(
              value: _selectedView,
              onChanged: (value) {
                setState(() {
                  _selectedView = value!;
                });
              },
              items: ['Requested to Me', 'My Request']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: isRequestedToMe
                ? ListView.builder(
                    itemCount: requestedToMe.length,
                    itemBuilder: (context, index) {
                      final item = requestedToMe[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['item']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text('Requested by: ${item['from']}'),
                              Text('Quantity: ${item['quantity']} Units'),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => _handleAccept(index),
                                    style: TextButton.styleFrom(backgroundColor: Colors.green[400]),
                                    child: const Text('Accept', style: TextStyle(color: Colors.white)),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () => _handleCancel(index),
                                    style: TextButton.styleFrom(backgroundColor: Colors.red[400]),
                                    child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: myRequests.length,
                    itemBuilder: (context, index) {
                      final item = myRequests[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['item']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text('To: ${item['to']}'),
                              Text('Quantity: ${item['quantity']} Units'),
                              Text(
                                'Status: ${item['status']}',
                                style: TextStyle(
                                  color: item['status'] == 'Accepted'
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
