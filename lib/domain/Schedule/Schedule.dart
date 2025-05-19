import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  String? id;
  final String workshopName;
  final String workshopAddress;
  final String foremanRequired;
  final double payrollPerHour;
  final DateTime workDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Schedule({
    this.id,
    required this.workshopName,
    required this.workshopAddress,
    required this.foremanRequired,
    required this.payrollPerHour,
    required this.workDate,
    required this.startTime,
    required this.endTime,
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'workshopName': workshopName,
      'workshopAddress': workshopAddress,
      'foremanRequired': foremanRequired,
      'payrollPerHour': payrollPerHour,
      'workDate': workDate.millisecondsSinceEpoch,
      'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
      'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Create from Firebase document
  factory Schedule.fromMap(String id, Map<String, dynamic> map) {
    return Schedule(
      id: id,
      workshopName: map['workshopName'] ?? '',
      workshopAddress: map['workshopAddress'] ?? '',
      foremanRequired: map['foremanRequired'] ?? '',
      payrollPerHour: (map['payrollPerHour'] ?? 0.0).toDouble(),
      workDate: DateTime.fromMillisecondsSinceEpoch(map['workDate'] ?? 0),
      startTime: TimeOfDay(
        hour: (map['startTime']?['hour'] ?? 0),
        minute: (map['startTime']?['minute'] ?? 0),
      ),
      endTime: TimeOfDay(
        hour: (map['endTime']?['hour'] ?? 0),
        minute: (map['endTime']?['minute'] ?? 0),
      ),
    );
  }

  // Helper method to format time for display (without context)
  String formattedTimeRange(BuildContext context) {
    return '${startTime.format(context)} - ${endTime.format(context)}';
  }

  // Alternative time formatting without context dependency
  String get timeRangeString {
    final startHour = startTime.hour.toString().padLeft(2, '0');
    final startMinute = startTime.minute.toString().padLeft(2, '0');
    final endHour = endTime.hour.toString().padLeft(2, '0');
    final endMinute = endTime.minute.toString().padLeft(2, '0');
    return '$startHour:$startMinute - $endHour:$endMinute';
  }

  // Helper method to format date for display
  String get formattedDate {
    final day = workDate.day.toString().padLeft(2, '0');
    final month = workDate.month.toString().padLeft(2, '0');
    final year = workDate.year.toString();
    return '$day/$month/$year';
  }

  // Additional helper to get DateTime for both date and start time
  DateTime get startDateTime {
    return DateTime(
      workDate.year,
      workDate.month,
      workDate.day,
      startTime.hour,
      startTime.minute,
    );
  }

  // Additional helper to get DateTime for both date and end time
  DateTime get endDateTime {
    return DateTime(
      workDate.year,
      workDate.month,
      workDate.day,
      endTime.hour,
      endTime.minute,
    );
  }


}