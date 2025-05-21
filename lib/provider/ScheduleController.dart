import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mastergig_app/domain/Schedule/Schedule.dart';
import 'dart:async';


class ScheduleController {
  final CollectionReference _schedulesCollection =
      FirebaseFirestore.instance.collection('schedules');

  // Add a new schedule (existing)
  Future<String> addSchedule(Schedule schedule) async {
    try {
      // Force status to available if not set
      final scheduleMap = schedule.toMap();
      scheduleMap['scheduleStatus'] = 'available';
      
      debugPrint('Creating schedule with: $scheduleMap');
      DocumentReference docRef = await _schedulesCollection.add(scheduleMap);
      debugPrint('Schedule created with ID: ${docRef.id}');
      
      // Verify the document was created correctly
      final createdDoc = await docRef.get();
      debugPrint('Created document data: ${createdDoc.data()}');
      
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating schedule: $e');
      throw 'Failed to add schedule: $e';
    }
  }

  // Get all schedules ordered by creation date (existing)
  Stream<List<Schedule>> get schedulesStream {
    return _schedulesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Schedule.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get available schedules for foreman selection
  Stream<List<Schedule>> getAvailableSchedules() {
    return _schedulesCollection
        .where('scheduleStatus', isEqualTo: 'available')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Schedule.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  void debugFetchAllSchedules() async {
    try {
      final query = await FirebaseFirestore.instance.collection('schedules').get();
      debugPrint('Total schedules in Firestore: ${query.docs.length}');
      query.docs.forEach((doc) {
        debugPrint('Schedule ${doc.id}: ${doc.data()}');
      });
    } catch (e) {
      debugPrint('Debug fetch error: $e');
    }
  }

  // Get a single schedule by ID (existing)
  Future<Schedule> getSchedule(String id) async {
    try {
      DocumentSnapshot doc = await _schedulesCollection.doc(id).get();
      if (doc.exists) {
        return Schedule.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      throw 'Schedule not found';
    } catch (e) {
      throw 'Failed to get schedule: $e';
    }
  }

  // Update a schedule (existing)
  Future<void> updateSchedule(Schedule schedule) async {
    try {
      await _schedulesCollection.doc(schedule.id).update(schedule.toMap());
    } catch (e) {
      throw 'Failed to update schedule: $e';
    }
  }

  // Accept a schedule by foreman
  Future<void> acceptSchedule(String scheduleId, String foremanId) async {
    try {
      final scheduleRef = _schedulesCollection.doc(scheduleId);
      
      await scheduleRef.update({
        'scheduleStatus': 'accepted',
        'acceptedBy': foremanId,
        'acceptedAt': FieldValue.serverTimestamp(),
        'foremanRequired': FieldValue.increment(-1), // This handles the decrement atomically
      });
    } catch (e) {
      debugPrint('Error accepting schedule: $e');
      throw 'Failed to accept schedule: $e';
    }
  }

  Future<void> removeSchedule(String scheduleId, String foremanId) async {
    try {
      final scheduleRef = _schedulesCollection.doc(scheduleId);
      
      await scheduleRef.update({
        'scheduleStatus': 'available',
        'acceptedBy': null,
        'acceptedAt': null,
        'foremanRequired': FieldValue.increment(1), // This handles the decrement atomically
      });
    } catch (e) {
      debugPrint('Error accepting schedule: $e');
      throw 'Failed to accept schedule: $e';
    }
  }

  // Check for schedule clash
 // Check for schedule clash (date-only version)
  Future<bool> checkForScheduleClash(String foremanId, Schedule newSchedule) async {
    try {
      final querySnapshot = await _schedulesCollection
          .where('acceptedBy', isEqualTo: foremanId)
          .where('scheduleStatus', isEqualTo: 'accepted')
          .get();

      final acceptedSchedules = querySnapshot.docs
          .map((doc) => Schedule.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();

      for (final existingSchedule in acceptedSchedules) {
        // Compare year, month, and day only
        if (existingSchedule.workDate == newSchedule.workDate) {
          debugPrint('Date clash detected:');
          debugPrint('Existing: ${existingSchedule.workshopName} on ${existingSchedule.workDate}');
          debugPrint('New: ${newSchedule.workshopName} on ${newSchedule.workDate}');
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error checking schedule clash: $e');
      return false;
    }
  }

  // Get schedules for a specific date (existing)
  Stream<List<Schedule>> getSchedulesByDate(DateTime date) {
    DateTime startDate = DateTime(date.year, date.month, date.day);
    DateTime endDate = DateTime(date.year, date.month, date.day + 1);
    
    return _schedulesCollection
        .where('workDate', isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch)
        .where('workDate', isLessThan: endDate.millisecondsSinceEpoch)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Schedule.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get accepted schedules by a specific foreman
  Stream<List<Schedule>> getAcceptedSchedulesByForeman(String foremanId) {
    return _schedulesCollection
        .where('acceptedBy', isEqualTo: foremanId)
        .where('scheduleStatus', isEqualTo: 'accepted')
        .orderBy('workDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Schedule.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }


  // Add this to your ScheduleController class

  // Function to check and delete schedules older than 24 hours
  Future<void> deleteExpiredSchedules() async {
    try {
      // Calculate the cutoff time (24 hours ago)
      final cutoffTime = DateTime.now().subtract(const Duration(days: 1));
      
      debugPrint('Checking for schedules older than: $cutoffTime');
      
      // Query schedules older than 24 hours
      final querySnapshot = await _schedulesCollection
          .where('createdAt', isLessThan: cutoffTime.millisecondsSinceEpoch)
          .get();

      debugPrint('Found ${querySnapshot.docs.length} expired schedules');
      
      // Delete each expired schedule
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
        debugPrint('Marked schedule ${doc.id} for deletion');
      }
      
      // Commit the batch delete
      await batch.commit();
      debugPrint('Successfully deleted ${querySnapshot.docs.length} expired schedules');
    } catch (e) {
      debugPrint('Error deleting expired schedules: $e');
      throw 'Failed to delete expired schedules: $e';
    }
  }

  // Add this function to run the cleanup periodically
  void startScheduleCleanupTask() {
    // Run immediately when called
    deleteExpiredSchedules();
    
    // Then run every 24 hours
    Timer.periodic(const Duration(hours: 24), (timer) {
      deleteExpiredSchedules();
    });
  }

}