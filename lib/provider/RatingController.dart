import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mastergig_app/domain/Rating/Rating.dart';

class RatingController with ChangeNotifier {
  final List<Rating> _ratings = [];
  final CollectionReference ratingsCollection =
      FirebaseFirestore.instance.collection('ratings');

  List<Rating> get ratings => List.unmodifiable(_ratings);

  /// Adds rating (works for both owner and foreman)
  Future<void> addRating(Rating rating) async {
    try {
      final docRef = await ratingsCollection.add(rating.toMap());
      final newRating = rating.copyWith(id: docRef.id);
      _ratings.add(newRating);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding rating: $e');
      rethrow;
    }
  }

  /// Fetches ratings filtered by role (use 'Foreman' for foreman ratings)
  Future<void> fetchRatingsByRole(String role) async {
    try {
      final snapshot = await ratingsCollection
          .where('role', isEqualTo: role)
          .orderBy('createdAt', descending: true)
          .get();
          
      _ratings.clear();
      for (var doc in snapshot.docs) {
        _ratings.add(Rating.fromMap(doc.data() as Map<String, dynamic>, doc.id));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching ratings by role: $e');
    }
  }

  /// Updates rating (works for both owner and foreman)
  Future<void> updateRating(Rating updatedRating) async {
    try {
      await ratingsCollection.doc(updatedRating.id).update(updatedRating.toMap());
      final index = _ratings.indexWhere((r) => r.id == updatedRating.id);
      if (index != -1) {
        _ratings[index] = updatedRating;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating rating: $e');
      rethrow;
    }
  }
  /// Clears local ratings list
  void clearRatings() {
    _ratings.clear();
    notifyListeners();
  }

  
}
