import 'package:flutter/material.dart';
import 'package:mastergig/domain/Schedule/Schedule.dart';
import 'package:mastergig/provider/ScheduleController.dart';
import 'package:provider/provider.dart';

class OwnerAddFormSchedulePage extends StatefulWidget {
  const OwnerAddFormSchedulePage({Key? key}) : super(key: key);

  @override
  _OwnerAddFormSchedulePageState createState() => _OwnerAddFormSchedulePageState();
}

class _OwnerAddFormSchedulePageState extends State<OwnerAddFormSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _workshopNameController = TextEditingController();
  final TextEditingController _workshopAddressController = TextEditingController();
  final TextEditingController _foremanController = TextEditingController();
  final TextEditingController _payrollController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
        _endTime = TimeOfDay(hour: picked.hour + 1, minute: picked.minute);
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Create schedule object
      final schedule = Schedule(
        foremanId: _foremanController.text,
        workshopId: '', // You'll need to get this from your auth system
        date: _selectedDate,
        startTime: _startTime,
        endTime: _endTime,
        workshopName: _workshopNameController.text,
        workshopAddress: _workshopAddressController.text,
        payrollPerHour: double.tryParse(_payrollController.text) ?? 0.0,
      );

      try {
        await Provider.of<ScheduleController>(context, listen: false)
            .addSchedule(schedule);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule added successfully!')),
        );
        
        // Clear form after submission
        _workshopNameController.clear();
        _workshopAddressController.clear();
        _foremanController.clear();
        _payrollController.clear();
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding schedule: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _workshopNameController.dispose();
    _workshopAddressController.dispose();
    _foremanController.dispose();
    _payrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MasterBig - Add Schedule'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Workshop Name
              TextFormField(
                controller: _workshopNameController,
                decoration: const InputDecoration(
                  labelText: 'Workshop Name',
                  hintText: 'Enter Workshop Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter workshop name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Workshop Address
              TextFormField(
                controller: _workshopAddressController,
                decoration: const InputDecoration(
                  labelText: 'Workshop Address',
                  hintText: 'Enter Workshop Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter workshop address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Required Foreman
              TextFormField(
                controller: _foremanController,
                decoration: const InputDecoration(
                  labelText: 'Required Foreman',
                  hintText: 'Enter Foreman Required',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a foreman';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Payroll Per Hour
              TextFormField(
                controller: _payrollController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Payroll Per Hour',
                  hintText: 'Enter Given Payroll',
                  border: OutlineInputBorder(),
                  prefixText: 'RM ',
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
              const SizedBox(height: 20),

              // Date Picker
              ListTile(
                title: const Text('Schedule Date'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 10),

              // Time Pickers
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Start Time'),
                      subtitle: Text(_startTime.format(context)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _selectStartTime(context),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('End Time'),
                      subtitle: Text(_endTime.format(context)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _selectEndTime(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),

              // Add Schedule Button
              OutlinedButton(
                onPressed: () {
                  // Add logic to add another schedule
                  _submitForm();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Add Schedule',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}