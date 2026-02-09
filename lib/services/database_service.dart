import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create Booking
  Future<void> createBooking(Booking booking) async {
    await _db.collection('bookings').doc(booking.id).set(booking.toMap());
  }

  // Get User Bookings
  Stream<List<Booking>> getUserBookings(String userId) {
    return _db
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Admin: Get All Bookings
  Stream<List<Booking>> getAllBookings() {
    return _db
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Admin: Update Booking Status
  Future<void> updateBookingStatus(String bookingId, BookingStatus status, {String? reason}) async {
    await _db.collection('bookings').doc(bookingId).update({
      'status': status.name,
      if (reason != null) 'rejectionReason': reason,
    });
  }

  // Dashboard Stats
  Future<Map<String, int>> getDashboardStats() async {
    QuerySnapshot snapshot = await _db.collection('bookings').get();
    int total = snapshot.docs.length;
    int confirmed = snapshot.docs.where((doc) => doc['status'] == 'confirmed').length;
    int pending = snapshot.docs.where((doc) => doc['status'] == 'pending').length;
    return {
      'total': total,
      'confirmed': confirmed,
      'pending': pending,
    };
  }
}
