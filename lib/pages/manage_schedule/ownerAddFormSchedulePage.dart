import 'package:flutter/material.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';

class OwnerAddFormSchedulePage extends StatefulWidget {
  const OwnerAddFormSchedulePage({super.key});

  @override
  State<OwnerAddFormSchedulePage> createState() => _OwnerAddFormSchedulePageState();
}

class _OwnerAddFormSchedulePageState extends State<OwnerAddFormSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _workshopNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _foremanController = TextEditingController();
  final TextEditingController _payrollController = TextEditingController();
  
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ownerHeader(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Centered heading outside the container
            const Text(
              'Add Working Schedule',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Form container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Workshop Name
                    const Text(
                      'Workshop Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _workshopNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Workshop Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter workshop name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    
                    // Time Row
                    const Text(
                      'Working Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectTime(context, true),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                              child: Text(
                                _startTime.format(context),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('to'),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectTime(context, false),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                              child: Text(
                                _endTime.format(context),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    
                    // Work Date
                    const Text(
                      'Work Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        child: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Workshop Address
                    const Text(
                      'Workshop Address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Enter Workshop Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter workshop address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    
                    // Required Foreman
                    const Text(
                      'Required Foreman',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _foremanController,
                      decoration: InputDecoration(
                        hintText: 'Enter Foreman Required',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a foreman';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    
                    // Payroll Per Hour
                    const Text(
                      'Payroll Per Hour',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _payrollController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter Given Payroll',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixText: 'RM ',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter payroll amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Schedule added successfully!')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFF18E),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                              side: BorderSide(  // NEW: Black border around AppBar
                              color: Colors.black,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Add the two buttons beneath the form
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Opacity(
                    opacity: 0.5, // Make the button semi-transparent
                    child: ElevatedButton(
                      onPressed: null, // Disable the button
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF9BE08),
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
                        'Add Schedule',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add navigation to view schedule list
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xEEEFD30B),
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
                      'View Schedule List',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: ownerFooter(context),
    );
  }

  @override
  void dispose() {
    _workshopNameController.dispose();
    _addressController.dispose();
    _foremanController.dispose();
    _payrollController.dispose();
    super.dispose();
  }
}