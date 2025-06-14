import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final String id;
  final String name;
  final String role;
  final String userType;
  final String workshopName;
  final String feedback;
  final int amenities;
  final int performance;
  final DateTime workDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Rating({
    this.id = '',
    required this.name,
    required this.role,
    required this.userType,
    required this.workshopName,
    required this.feedback,
    required this.amenities,
    required this.performance,
    required this.workDate,
    required this.startTime,
    required this.endTime,
  });

  /// ✅ Creates a copy of the current Rating object with optional new values
  Rating copyWith({
    String? id,
    String? name,
    String? userType,
    String? role,
    String? workshopName,
    String? feedback,
    int? amenities,
    int? performance,
    DateTime? workDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return Rating(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      userType: userType ?? this.userType,
      workshopName: workshopName ?? this.workshopName,
      feedback: feedback ?? this.feedback,
      amenities: amenities ?? this.amenities,
      performance: performance ?? this.performance,
      workDate: workDate ?? this.workDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  /// Converts Rating to Firestore-compatible Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'userType': userType,
      'workshopName': workshopName,
      'feedback': feedback,
      'amenities': amenities,
      'performance': performance,
      'workDate': workDate.millisecondsSinceEpoch,
      'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
      'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// Creates Rating from Firestore Map
  factory Rating.fromMap(Map<String, dynamic> map, [String id = '']) {
    return Rating(
      id: id,
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      userType: map['userType'] ?? '',
      workshopName: map['workshopName'] ?? '',
      feedback: map['feedback'] ?? '',
      amenities: map['amenities'] ?? 0,
      performance: map['performance'] ?? 0,
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

  /// ✅ Helper method to display time range in context
  String formattedTimeRange(BuildContext context) {
    return '${startTime.format(context)} - ${endTime.format(context)}';
  }

  /// ✅ Alternative time formatting (no context needed)
  String get timeRangeString {
    final startHour = startTime.hour.toString().padLeft(2, '0');
    final startMinute = startTime.minute.toString().padLeft(2, '0');
    final endHour = endTime.hour.toString().padLeft(2, '0');
    final endMinute = endTime.minute.toString().padLeft(2, '0');
    return '$startHour:$startMinute - $endHour:$endMinute';
  }

  /// ✅ Helper to display formatted date as DD/MM/YYYY
  String get formattedDate {
    final day = workDate.day.toString().padLeft(2, '0');
    final month = workDate.month.toString().padLeft(2, '0');
    final year = workDate.year.toString();
    return '$day/$month/$year';
  }

  /// ✅ Combine work date with start time as DateTime
  DateTime get startDateTime {
    return DateTime(
      workDate.year,
      workDate.month,
      workDate.day,
      startTime.hour,
      startTime.minute,
    );
  }

  /// ✅ Combine work date with end time as DateTime
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
