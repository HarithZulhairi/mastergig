import 'package:flutter/material.dart';
import 'package:mastergig_app/domain/Rating/Rating.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'package:mastergig_app/pages/manage_rating/ownerRatingPage.dart';

import 'package:intl/intl.dart';

class ownerRatingViewPage extends StatelessWidget {
  final Rating rating;

  const ownerRatingViewPage({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ownerHeader(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Title above the card
            const Text(
              'Foreman Details',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
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