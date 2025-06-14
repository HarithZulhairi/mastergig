import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String id;
  final String name;
  final String role;
  final String userType;
  final String workshopName;
  final String bankAccNum;
  final String bankName;
  final double payrollPerHour;
  final double totalPay;
  final DateTime workDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String status;

  Payment({
    this.id = '',
    required this.name,
    required this.role,
    required this.userType,
    required this.workshopName,
    required this.workDate,
    required this.startTime,
    required this.endTime,
    required this.payrollPerHour,
    required this.totalPay,
    required this.status,
    this.bankAccNum = '',
    this.bankName = '',
  });

  /// ✅ Creates a copy of the current Payment object with optional new values
  Payment copyWith({
    String? id,
    String? name,
    String? userType,
    String? role,
    String? workshopName,
    String? bankAccNum,
    String? bankName, 
    double? payrollPerHour,
    double? totalPay,
    String? status,
    DateTime? workDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return Payment(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      userType: userType ?? this.userType,
      workshopName: workshopName ?? this.workshopName,
      bankAccNum: bankAccNum ?? this.bankAccNum,
      bankName: bankName ?? this.bankName,
      payrollPerHour: payrollPerHour ?? this.payrollPerHour,
      totalPay: totalPay ?? this.totalPay,
      status: status ?? this.status,
      workDate: workDate ?? this.workDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  /// Converts Payment to Firestore-compatible Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'userType': userType,
      'workshopName': workshopName,
      'bankAccNum': bankAccNum,
      'bankName': bankName,
      'payrollPerHour': payrollPerHour,
      'totalPay': totalPay,
      'status': status,
      'workDate': workDate.millisecondsSinceEpoch,
      'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
      'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// Creates Payment from Firestore Map
  factory Payment.fromMap(Map<String, dynamic> map, [String id = '']) {
    return Payment(
      id: id,
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      userType: map['userType'] ?? '',
      workshopName: map['workshopName'] ?? '',
      bankAccNum: map['bankAccNum'] ?? '',
      bankName: map['bankName'] ?? '',
      payrollPerHour: (map['payrollPerHour'] ?? 0.0).toDouble(),
      totalPay: (map['totalPay'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
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
