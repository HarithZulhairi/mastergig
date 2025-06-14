import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mastergig_app/domain/Payroll/Payment.dart';
import 'package:mastergig_app/provider/PayrollController.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';

class payrollEditFormPage extends StatefulWidget {
  final Payment payment;

  const payrollEditFormPage({super.key, required this.payment});

  @override
  State<payrollEditFormPage> createState() => _payrollEditFormPageState();
}

class _payrollEditFormPageState extends State<payrollEditFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bankAccNumController;
  late TextEditingController _bankNameController;
  late TextEditingController _payrollPerHourController;

  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late DateTime _selectedDate;
  final PayrollController _payrollController = PayrollController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.payment.name);
    _bankAccNumController = TextEditingController(text: widget.payment.bankAccNum);
    _bankNameController = TextEditingController(text: widget.payment.bankName);
    _payrollPerHourController =
        TextEditingController(text: widget.payment.payrollPerHour.toString());
    _startTime = widget.payment.startTime;
    _endTime = widget.payment.endTime;
    _selectedDate = widget.payment.workDate;
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
      final payrollPerHour = double.tryParse(_payrollPerHourController.text) ?? 0.0;
      final hoursWorked = _endTime.hour - _startTime.hour + (_endTime.minute - _startTime.minute) / 60;
      final totalPay = payrollPerHour * hoursWorked;

      final updatedPayment = widget.payment.copyWith(
        name: _nameController.text.trim(),
        bankAccNum: _bankAccNumController.text.trim(),
        bankName: _bankNameController.text.trim(),
        payrollPerHour: payrollPerHour,
        totalPay: totalPay,
        workDate: _selectedDate,
        startTime: _startTime,
        endTime: _endTime,
      );

      await _payrollController.updatePayroll(widget.payment.id, updatedPayment);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(); // Go back
          });
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Center(
              child: Text(
                'Payroll Updated!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            content: const Icon(Icons.check_circle, color: Colors.green, size: 100),
          );
        },
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
    _nameController.dispose();
    _bankAccNumController.dispose();
    _bankNameController.dispose();
    _payrollPerHourController.dispose();
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
              'Edit Payroll',
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
                      label: 'Foreman Name',
                      controller: _nameController,
                      hint: 'Enter Foreman Name',
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter name' : null,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      label: 'Bank Account Number',
                      controller: _bankAccNumController,
                      hint: 'Enter Account Number',
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter account number' : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      label: 'Bank Name',
                      controller: _bankNameController,
                      hint: 'Enter Bank Name',
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter bank name' : null,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      label: 'Payroll Per Hour (RM)',
                      controller: _payrollPerHourController,
                      hint: 'Enter Hourly Rate',
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter hourly rate';
                        if (double.tryParse(value) == null) return 'Please enter a valid number';
                        return null;
                      },
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 15),
                    _buildTimePickerRow(context),
                    const SizedBox(height: 15),
                    _buildDatePicker(context),
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
                                'Update Payroll',
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
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
        ),
      ],
    );
  }

  Widget _buildTimePickerRow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Working Hours', style: TextStyle(fontWeight: FontWeight.bold)),
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
}
