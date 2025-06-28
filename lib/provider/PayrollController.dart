import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mastergig_app/domain/Payroll/Payment.dart';

class PayrollController {
  final CollectionReference _paymentCollection =
      FirebaseFirestore.instance.collection('payments'); // Changed from payrolls
  Future<void> addPayroll(Payment payment) async {
    try {
      await _paymentCollection.add(payment.toMap()); // Changed _payrollCollection
    } catch (e) {
      throw Exception('Failed to add payment: $e'); // Updated error message
    }
  }

  Stream<List<Payment>> getPayrollsStream() {
    return _paymentCollection // Changed from _payrollCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Payment.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  /// ✅ Get a single payroll by ID
  Future<Payment> getPayrollById(String id) async {
    try {
      final doc = await _paymentCollection.doc(id).get();
      if (doc.exists) {
        return Payment.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        throw Exception('Payroll not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch payroll: $e');
    }
  }

  /// ✅ Update a payroll by ID
  Future<void> updatePayroll(String id, Payment updatedPayment) async {
    try {
      await _paymentCollection.doc(id).update(updatedPayment.toMap());
    } catch (e) {
      throw Exception('Failed to update payroll: $e');
    }
  }

  /// ✅ Delete a payroll by ID
  Future<void> deletePayroll(String id) async {
    try {
      await _paymentCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete payroll: $e');
    }
  }
}
