import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/booking.dart';

class BookingProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Create a new booking (Used by both App and potentially Website)
  Future<bool> createBooking({
    required String userId,
    required String userName,
    required String phone,
    required DateTime checkIn,
    required DateTime checkOut,
    required String guestName,
    required String roomType,
    File? paymentImage,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      String? paymentImageUrl;
      if (paymentImage != null) {
        String fileName = 'payments/${DateTime.now().millisecondsSinceEpoch}.jpg';
        TaskSnapshot snapshot = await _storage.ref().child(fileName).putFile(paymentImage);
        paymentImageUrl = await snapshot.ref.getDownloadURL();
      }

      Booking booking = Booking(
        id: _firestore.collection('bookings').doc().id,
        userId: userId,
        userName: userName,
        phone: phone,
        checkIn: checkIn,
        checkOut: checkOut,
        guestName: guestName,
        roomType: roomType,
        paymentImageUrl: paymentImageUrl,
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('bookings').doc(booking.id).set(booking.toMap());

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("Error creating booking: $e");
      return false;
    }
  }

  // Stream of all bookings for Admin
  Stream<List<Booking>> allBookings() {
    return _firestore
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Stream of bookings for today
  Stream<List<Booking>> getBookingsForDate(DateTime date) {
    DateTime start = DateTime(date.year, date.month, date.day);
    DateTime end = start.add(const Duration(days: 1));

    return _firestore
        .collection('bookings')
        .where('checkIn', isGreaterThanOrEqualTo: start)
        .where('checkIn', isLessThan: end)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateStatus(String bookingId, BookingStatus status, {String? reason}) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': status.name,
      'rejectionReason': reason,
    });
  }
}
