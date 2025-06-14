import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mastergig_app/domain/Payroll/Payment.dart';

class payrollViewPage extends StatelessWidget {
  final Payment payment;

  const payrollViewPage({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final totalDuration = _calculateTotalDuration(payment.startTime, payment.endTime);
    final formattedTotalHours = _formatDuration(totalDuration);
    final formattedWorkDate = DateFormat('dd MMM yyyy').format(payment.workDate);
    final formattedTotalPay = NumberFormat.currency(symbol: 'RM ', decimalDigits: 2).format(payment.totalPay);

    return Scaffold(
      appBar: AppBar(
        title: Text(payment.name),
        backgroundColor: const Color(0xFFFFF18E),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payroll Details',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Card with all payroll info
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Name:', payment.name),
                    _buildDetailRow('Work Date:', formattedWorkDate),
                    _buildDetailRow('Total Hours:', formattedTotalHours),
                    _buildDetailRow('Total Pay:', formattedTotalPay),
                    _buildDetailRow('Bank Account:', payment.bankAccNum),
                    _buildDetailRow('Bank Name:', payment.bankName),
                  ],
                ),
              ),
            ),

            // Buttons Row
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Back Button
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Pay Button
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement payment functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payment functionality will be implemented here'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Pay',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 20, color: Color(0xEE555555)),
            ),
          ),
        ],
      ),
    );
  }

  Duration _calculateTotalDuration(TimeOfDay start, TimeOfDay end) {
    final startDateTime = DateTime(0, 0, 0, start.hour, start.minute);
    final endDateTime = DateTime(0, 0, 0, end.hour, end.minute);
    return endDateTime.difference(startDateTime);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')} hours ${minutes.toString().padLeft(2, '0')} minutes';
  }
}