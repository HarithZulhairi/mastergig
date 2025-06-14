import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mastergig_app/pages/Manage_login/Login.dart';
import 'package:mastergig_app/pages/manage_schedule/ownerAddFormSchedulePage.dart';
import 'package:mastergig_app/pages/manage_schedule/foremanSelectSchedulePage.dart';
import 'package:mastergig_app/pages/manage_inventory/inventoryAddFormPage.dart'; // <--- NEW IMPORT
import 'firebase_options.dart';
import 'package:mastergig_app/provider/ScheduleController.dart';
import 'package:mastergig_app/pages/manage_rating/ownerRatingPage.dart';
import 'package:mastergig_app/pages/manage_rating/foremanRatingPage.dart';
import 'package:mastergig_app/pages/manage_payroll/payrollPage.dart';
import 'package:mastergig_app/services/stripe_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await StripeService.initialize();
  ScheduleController().startScheduleCleanupTask();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MasterGig Workshop',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FirebaseTestScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _testController = TextEditingController();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkFirebaseConnection();
  }

  Future<void> _checkFirebaseConnection() async {
    try {
      await _firestore.collection('test').limit(1).get();
      setState(() {
        _isConnected = true;
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
      });
      debugPrint('Firebase connection error: $e');
    }
  }

  Future<void> _addTestData() async {
    if (_testController.text.isEmpty) return;

    try {
      await _firestore.collection('test').add({
        'message': _testController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _testController.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Data added successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding data: $e')));
    }
  }

  @override
  void dispose() {
    _testController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Connection Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isConnected ? Icons.check_circle : Icons.error,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  _isConnected
                      ? 'Connected to Firebase'
                      : 'Not connected to Firebase',
                  style: TextStyle(
                    color: _isConnected ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Firebase Test Form',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _testController,
              decoration: const InputDecoration(
                labelText: 'Enter test message',
                border: OutlineInputBorder(),
                hintText: 'Type something to test Firebase',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTestData,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Submit to Firestore'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Go to Register Page'),
            ),
            const SizedBox(height: 30),
            const Text(
              'Firestore Test Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('test')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Text('No test data yet');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(doc['message']),
                        subtitle: Text(
                          doc['timestamp']?.toDate().toString() ?? 'No timestamp',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await doc.reference.delete();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OwnerAddFormSchedulePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Go to Schedule Management',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForemanSelectSchedulePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Go to Select Foreman',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // 🔹 NEW: Go to Add Inventory Form
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InventoryAddFormPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Go to Add Inventory Form',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // 🔹 NEW: Go to Owner Rating Page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ownerRatingPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Owner Rating Page',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            
            // NEW: Foreman Rating Page Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => foremanRatingPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Different color to distinguish
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Foreman Rating Page',
                style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ownerPayrollPage(),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.teal,
    minimumSize: const Size(double.infinity, 50),
  ),
  child: const Text(
    'Go to Payroll Page',
    style: TextStyle(fontSize: 16, color: Colors.white),
  ),
),
const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
