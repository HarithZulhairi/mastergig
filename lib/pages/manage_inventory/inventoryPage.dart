import 'package:flutter/material.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/domain/Inventory/Inventory.dart';
import 'package:mastergig_app/pages/manage_inventory/inventoryAddFormPage.dart';
import 'package:mastergig_app/provider/InventoryController.dart';

class InventoryPage extends StatelessWidget {
  final InventoryController _inventoryController = InventoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ownerHeader(context),
      bottomNavigationBar: ownerFooter(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'List of Inventory',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Spacer(),
                Icon(Icons.filter_alt_outlined, color: Colors.black),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Inventory>>(
                future: _inventoryController.getInventoryList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());

                  if (!snapshot.hasData || snapshot.data!.isEmpty)
                    return Center(child: Text('No inventory available.'));

                  final inventoryList = snapshot.data!;
                  return ListView.builder(
                    itemCount: inventoryList.length,
                    itemBuilder: (context, index) {
                      final item = inventoryList[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              SizedBox(height: 4),
                              Text('${item.quantity} Units'),
                              Text(item.supplier),
                              Text(item.notes),
                              Text(item.category),
                              Text(
                                'RM${item.unitPrice.toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Shop: ${item.shopName}'),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add request logic
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text('Request'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InventoryAddFormPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Add Inventory',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
