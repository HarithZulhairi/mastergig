import 'package:flutter/material.dart';
import 'package:mastergig_app/domain/Rating/Rating.dart';
import 'package:intl/intl.dart';

class ownerRatingViewPage extends StatelessWidget {
  final Rating rating;

  const ownerRatingViewPage({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rating.name),
        backgroundColor: const Color(0xFFEFD30B),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title above the card
            const Text(
              'Foreman Details',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Card containing all details
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
                    // Personal Details Section
                    _buildDetailRow('Name:', rating.name),
                    _buildDetailRow('Role:', rating.role),
                    _buildDetailRow('Workshop:', rating.workshopName),
                    _buildDetailRow('Work Date:', DateFormat('dd MMM yyyy').format(rating.workDate)),
                    _buildDetailRow('Working Hours:', 
                      '${_formatTimeOfDay(rating.startTime)} - ${_formatTimeOfDay(rating.endTime)}'),
                    
                    // Performance Section
                    const SizedBox(height: 20),
                    const Text(
                      'Performance Rating:',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildPerformanceStars(rating.performance),
                        const SizedBox(width: 10),
                        Text(
                          '${rating.performance}/5',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),

                    // Feedback Section
                    const SizedBox(height: 30),
                    const Text(
                      'Feedback:',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        rating.feedback.isNotEmpty ? rating.feedback : 'No additional feedback provided.',
                        style: const TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Back Button
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
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
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xEE555555),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 30,
        );
      }),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat('h:mm a');
    return format.format(dt);
  }
}