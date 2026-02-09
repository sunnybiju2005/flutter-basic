import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, confirmed, rejected }

class Booking {
  final String id;
  final String userId;
  final String userName;
  final String phone;
  final DateTime checkIn;
  final DateTime checkOut;
  final String guestName;
  final String roomType; // Added roomType
  final String? idProofUrl;
  final String? paymentImageUrl;
  final BookingStatus status;
  final String? rejectionReason;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.userName,
    required this.phone,
    required this.checkIn,
    required this.checkOut,
    required this.guestName,
    required this.roomType, // Required now
    this.idProofUrl,
    this.paymentImageUrl,
    this.status = BookingStatus.pending,
    this.rejectionReason,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'phone': phone,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'guestName': guestName,
      'roomType': roomType,
      'idProofUrl': idProofUrl,
      'paymentImageUrl': paymentImageUrl,
      'status': status.name,
      'rejectionReason': rejectionReason,
      'createdAt': createdAt,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map, String id) {
    return Booking(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      phone: map['phone'] ?? '',
      checkIn: map['checkIn'] is Timestamp ? (map['checkIn'] as Timestamp).toDate() : (map['checkIn'] as DateTime),
      checkOut: map['checkOut'] is Timestamp ? (map['checkOut'] as Timestamp).toDate() : (map['checkOut'] as DateTime),
      guestName: map['guestName'] ?? '',
      roomType: map['roomType'] ?? 'Standard Room',
      idProofUrl: map['idProofUrl'],
      paymentImageUrl: map['paymentImageUrl'],
      status: BookingStatus.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'pending'),
        orElse: () => BookingStatus.pending,
      ),
      rejectionReason: map['rejectionReason'],
      createdAt: map['createdAt'] is Timestamp ? (map['createdAt'] as Timestamp).toDate() : (map['createdAt'] as DateTime),
    );
  }
}
