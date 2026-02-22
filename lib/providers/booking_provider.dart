import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import '../models/booking.dart';

class BookingProvider extends ChangeNotifier {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;
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

      // Mock delay
      await Future.delayed(const Duration(seconds: 1));

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
    return Stream.value([
      Booking(
        id: '1',
        userId: 'u1',
        userName: 'John Doe',
        phone: '1234567890',
        checkIn: DateTime.now(),
        checkOut: DateTime.now().add(const Duration(days: 2)),
        guestName: 'John Doe',
        roomType: 'Deluxe Room',
        status: BookingStatus.confirmed,
        createdAt: DateTime.now(),
      ),
      Booking(
        id: '2',
        userId: 'u2',
        userName: 'Jane Smith',
        phone: '0987654321',
        checkIn: DateTime.now().add(const Duration(days: 1)),
        checkOut: DateTime.now().add(const Duration(days: 3)),
        guestName: 'Jane Smith',
        roomType: 'Suite',
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
      ),
    ]);
  }

  // Stream of bookings for today
  Stream<List<Booking>> getBookingsForDate(DateTime date) {
    return Stream.value([
      Booking(
        id: '1',
        userId: 'u1',
        userName: 'John Doe',
        phone: '1234567890',
        checkIn: DateTime.now(),
        checkOut: DateTime.now().add(const Duration(days: 2)),
        guestName: 'John Doe',
        roomType: 'Deluxe Room',
        status: BookingStatus.confirmed,
        createdAt: DateTime.now(),
      ),
    ]);
  }

  Future<void> updateStatus(String bookingId, BookingStatus status, {String? reason}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();
  }
}
