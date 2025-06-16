import 'package:flutter/material.dart';
import 'package:mastergig_app/pages/manage_rating/ownerRatingViewPage.dart';
import 'package:mastergig_app/pages/manage_rating/ownerRatingPage.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'package:mastergig_app/domain/Rating/Rating.dart';
import 'package:mastergig_app/provider/RatingController.dart';

class ownerRatingEditFormPage extends StatefulWidget {
  final Rating rating;

  const ownerRatingEditFormPage({super.key, required this.rating});

  @override
  State<ownerRatingEditFormPage> createState() => _ownerRatingEditFormPageState();
}

class _ownerRatingEditFormPageState extends State<ownerRatingEditFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _workshopNameController;
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _feedbackController;

  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late DateTime _selectedDate;
  late int _performance;

  final RatingController _ratingController = RatingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _workshopNameController = TextEditingController(text: widget.rating.workshopName);
    _nameController = TextEditingController(text: widget.rating.name);
    _roleController = TextEditingController(text: widget.rating.role);
    _feedbackController = TextEditingController(text: widget.rating.feedback);
    _startTime = widget.rating.startTime;
    _endTime = widget.rating.endTime;
    _selectedDate = widget.rating.workDate;
    _performance = widget.rating.performance;
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final picked = await showTimePicker(
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
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isSubmitting = true);

  try {
    final updatedRating = Rating(
      id: widget.rating.id, // <-- Add this line to include the original ID
      name: _nameController.text.trim(),
      role: _roleController.text.trim(),
      userType: 'Owner',
      workshopName: _workshopNameController.text.trim(),
      feedback: _feedbackController.text.trim(),
      performance: _performance,
      workDate: _selectedDate,
      startTime: _startTime,
      endTime: _endTime,
      amenities: widget.rating.amenities,
    );

    await _ratingController.updateRating(updatedRating); // <-- Add await here

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rating updated successfully!')),
      );

    // Navigate back to view page after successful update
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ownerRatingPage(),
        ),
      );  


  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    setState(() => _isSubmitting = false);
  }
}

  @override
  void dispose() {
    _workshopNameController.dispose();
    _nameController.dispose();
    _roleController.dispose();
    _feedbackController.dispose();
    super.dispose();
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
              'Edit Rating',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      label: 'Name',
                      controller: _nameController,
                      hint: 'Enter Name',
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter name' : null,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      label: 'Role',
                      controller: _roleController,
                      hint: 'Foreman',
                      readOnly: true,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      label: 'Feedback',
                      controller: _feedbackController,
                      hint: 'Enter Feedback',
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter feedback' : null,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      label: 'Workshop Name',
                      controller: _workshopNameController,
                      hint: 'Enter Workshop Name',
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter workshop name' : null,
                    ),
                    const SizedBox(height: 15),
                    _buildTimePickerRow(context),
                    const SizedBox(height: 15),
                    _buildDatePicker(context),
                    const SizedBox(height: 15),
                    _buildPerformanceSelector(),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFF18E),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.black, width: 0.5),
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
                          builder: (context) => const ownerRatingPage(),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildTimePickerRow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Working Time', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectTime(context, true),
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  child: Text(_startTime.format(context), style: const TextStyle(fontSize: 16)),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  child: Text(_endTime.format(context), style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Work Date', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        InkWell(
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.all(12),
            ),
            child: Text(
              '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance (1 - 5)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starNumber = index + 1;
            return IconButton(
              icon: Icon(
                starNumber <= _performance ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 40,
              ),
              onPressed: () {
                setState(() {
                  _performance = starNumber;
                });
              },
            );
          }),
        ),
        const SizedBox(height: 5),
        Center(
          child: Text(
            '$_performance/5',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
