import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mastergig_app/domain/Schedule/Schedule.dart';

class ScheduleController {
  final CollectionReference _schedulesCollection =
      FirebaseFirestore.instance.collection('schedules');

  // Add a new schedule
  Future<String> addSchedule(Schedule schedule) async {
    try {
      // Add debug print to verify data before sending
      print('Adding schedule to Firebase: ${schedule.toMap()}');
      
      DocumentReference docRef = await _schedulesCollection.add(schedule.toMap());
      
      // Add debug print to verify document ID
      print('Schedule added with ID: ${docRef.id}');
      
      return docRef.id;
    } catch (e) {
      // Add more detailed error logging
      print('Error adding schedule: $e');
      throw 'Failed to add schedule: $e';
    }
  }

  // Get all schedules ordered by creation date
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

  // Get a single schedule by ID
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

  // Update a schedule
  Future<void> updateSchedule(Schedule schedule) async {
    try {
      await _schedulesCollection
          .doc(schedule.id)
          .update(schedule.toMap());
    } catch (e) {
      throw 'Failed to update schedule: $e';
    }
  }

  // Delete a schedule
  Future<void> deleteSchedule(String id) async {
    try {
      await _schedulesCollection.doc(id).delete();
    } catch (e) {
      throw 'Failed to delete schedule: $e';
    }
  }

  // Get schedules for a specific date
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
}