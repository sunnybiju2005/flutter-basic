import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: StreamBuilder<List<Booking>>(
        stream: bookingProvider.userBookings(auth.user!.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final bookings = snapshot.data!;
          if (bookings.isEmpty) return const Center(child: Text('No bookings found.'));

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Guest: ${booking.guestName}'),
                  subtitle: Text('Status: ${booking.status.name.toUpperCase()}\nDates: ${DateFormat('MMM dd').format(booking.checkIn)} - ${DateFormat('MMM dd').format(booking.checkOut)}'),
                  trailing: _getStatusIcon(booking.status),
                  isThreeLine: true,
                  onTap: () {
                    if (booking.status == BookingStatus.rejected) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Rejection Reason'),
                          content: Text(booking.rejectionReason ?? 'No reason provided.'),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return const Icon(Icons.check_circle, color: Colors.green);
      case BookingStatus.rejected:
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.hourglass_empty, color: Colors.orange);
    }
  }
}
