import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'package:mastergig_app/domain/Schedule/Schedule.dart';
import 'package:mastergig_app/provider/ScheduleController.dart';
import 'package:mastergig_app/pages/manage_schedule/ownerViewSchedulePage.dart';

class OwnerEditSchedulePage extends StatefulWidget {
  final Schedule schedule;
  final String scheduleId;

  const OwnerEditSchedulePage({
    super.key,
    required this.schedule,
    required this.scheduleId,
  });

  @override
  State<OwnerEditSchedulePage> createState() => _OwnerEditSchedulePageState();
}

class _OwnerEditSchedulePageState extends State<OwnerEditSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _workshopNameController;
  late TextEditingController _addressController;
  late TextEditingController _foremanController;
  late TextEditingController _payrollController;
  
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late DateTime _selectedDate;
  final ScheduleController _scheduleController = ScheduleController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing schedule data
    _workshopNameController = TextEditingController(text: widget.schedule.workshopName);
    _addressController = TextEditingController(text: widget.schedule.workshopAddress);
    _foremanController = TextEditingController(text: widget.schedule.foremanRequired);
    _payrollController = TextEditingController(text: widget.schedule.payrollPerHour.toString());
    
    _startTime = widget.schedule.startTime;
    _endTime = widget.schedule.endTime;
    _selectedDate = widget.schedule.workDate;
  }

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

  Future<void> _updateSchedule() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final updatedSchedule = Schedule(
        id: widget.scheduleId,
        workshopName: _workshopNameController.text.trim(),
        workshopAddress: _addressController.text.trim(),
        foremanRequired: _foremanController.text.trim(),
        payrollPerHour: double.parse(_payrollController.text.trim()),
        workDate: _selectedDate,
        startTime: _startTime,
        endTime: _endTime,
      );

      await _scheduleController.updateSchedule(updatedSchedule);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule updated successfully!')),
      );

      // Navigate back to view page after successful update
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OwnerViewSchedulePage(),
        ),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase error: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
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
            const Text(
              'Edit Working Schedule',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
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
                    
                    // Working Time
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
                          '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
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
                    
                    // Update Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _updateSchedule,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFF18E),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: _isSubmitting
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom buttons
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min, 
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OwnerViewSchedulePage(),
                        ),
                      );
                    },
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
                      'Back',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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