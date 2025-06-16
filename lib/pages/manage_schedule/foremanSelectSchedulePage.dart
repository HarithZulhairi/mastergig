import 'package:flutter/material.dart';
import 'package:mastergig_app/widgets/foremanHeader.dart';
import 'package:mastergig_app/widgets/foremanFooter.dart';
import 'package:mastergig_app/domain/Schedule/Schedule.dart';
import 'package:mastergig_app/pages/manage_schedule/foremanViewSchedulePage.dart';
import 'package:mastergig_app/provider/ScheduleController.dart';

class ForemanSelectSchedulePage extends StatefulWidget {
  final String foremanId = 'temp_foreman_id';

  const ForemanSelectSchedulePage({super.key});

  @override
  State<ForemanSelectSchedulePage> createState() => _ForemanSelectSchedulePageState();
}

class _ForemanSelectSchedulePageState extends State<ForemanSelectSchedulePage> {
  final ScheduleController _controller = ScheduleController();
  String? _clashMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: foremanHeader(context),
      body: StreamBuilder<List<Schedule>>(
        stream: _controller.getAvailableSchedules(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error fetching schedules: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final schedules = snapshot.data ?? [];
          print('Fetched ${schedules.length} available schedules');

          if (schedules.isEmpty) {
            print('No schedules found, but expected some. Checking Firestore...');
            _controller.debugFetchAllSchedules();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    'Select Available Schedule',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_clashMessage != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _clashMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                
                if (schedules.isEmpty)
                  const Text('No available schedules found')
                else
                  ...schedules.map((schedule) => _buildScheduleCard(context, schedule)),
                
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Opacity(
                    opacity: 0.5,
                    child: ElevatedButton(
                      onPressed: null, // Disabled
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
                        'Select New Schedule',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForemanViewSchedulePage(),
                        ),
                      );
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
                      'View My Schedules',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          foremanFooter(context),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context, Schedule schedule) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Colors.black,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: schedule.workshopName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' (${schedule.formattedDate} ${schedule.timeRangeString})',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              schedule.workshopAddress,
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xEE959595)
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Required ${schedule.foremanRequired} foremen left | RM${schedule.payrollPerHour.toStringAsFixed(2)} per hour',
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xEE959595)
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: schedule.isAvailable ? () async {
                        // Check for date clash
                        final hasClash = await _controller.checkForScheduleClash(widget.foremanId, schedule);
                        
                        setState(() {
                          _clashMessage = hasClash 
                              ? 'You already have a schedule on ${schedule.formattedDate}'
                              : null;
                        });

                        if (hasClash) return;

                        // Show confirmation dialog
                        bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      'Are you sure you want to select ${schedule.workshopName} schedule?',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(0.8),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: ElevatedButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFFFF7878),
                                                foregroundColor: Colors.black,
                                                padding: const EdgeInsets.symmetric(vertical: 20),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                  side: const BorderSide(color: Colors.black, width: 1),
                                                ),
                                              ),
                                              child: const Text(
                                                'No',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: ElevatedButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF1EEF0B),
                                                foregroundColor: Colors.black,
                                                padding: const EdgeInsets.symmetric(vertical: 20),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                  side: const BorderSide(color: Colors.black, width: 1),
                                                ),
                                              ),
                                              child: const Text(
                                                'Yes',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        if (confirm != true) return;

                        try {
                          await _controller.acceptSchedule(schedule.id!, widget.foremanId);
                          
                          // Show success dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              Future.delayed(const Duration(milliseconds: 1000), () {
                                Navigator.of(context).pop();
                              });
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                title: const Center(child: 
                                  Text(
                                    'Success!',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                    ),
                                  )
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.green, size: 100),
                                  ],
                                ),
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
                        }
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: schedule.isAvailable 
                            ? const Color(0xFFEFD30B)
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: Colors.black,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Text(
                        schedule.isAvailable ? 'Accept' : 'Accepted',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}