import 'dart:io';
import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';

class BookingProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final StorageService _storageService = StorageService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Create a new booking
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

      String? paymentUrl;
      if (paymentImage != null) {
        paymentUrl = await _storageService.uploadFile(paymentImage, 'payments/${DateTime.now().millisecondsSinceEpoch}.jpg');
      }

      final booking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        userName: userName,
        phone: phone,
        checkIn: checkIn,
        checkOut: checkOut,
        guestName: guestName,
        roomType: roomType,
        paymentImageUrl: paymentUrl,
        createdAt: DateTime.now(),
      );

      await _dbService.createBooking(booking);

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
    return _dbService.getAllBookings();
  }

  // Stream of bookings for current user
  Stream<List<Booking>> userBookings(String userId) {
    return _dbService.getUserBookings(userId);
  }

  // Stream of bookings for a specific date
  Stream<List<Booking>> getBookingsForDate(DateTime date) {
    return _dbService.getAllBookings().map((bookings) => bookings.where((b) {
      return b.checkIn.year == date.year && b.checkIn.month == date.month && b.checkIn.day == date.day;
    }).toList());
  }

  Future<void> updateStatus(String bookingId, BookingStatus status, {String? reason}) async {
    await _dbService.updateBookingStatus(bookingId, status, reason: reason);
    notifyListeners();
  }
}
