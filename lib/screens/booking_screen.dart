import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  final _guestNameController = TextEditingController();
  String _selectedRoomType = 'Standard Non-AC';
  File? _paymentImage;
  final _picker = ImagePicker();

  final List<String> _roomTypes = [
    'Standard Non-AC',
    'Standard AC',
    'Deluxe AC Room',
    'Classic Non-AC',
    'Suite Room',
  ];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _paymentImage = File(pickedFile.path);
      });
    }
  }

  void _submit() async {
    if (_checkIn == null || _checkOut == null || _guestNameController.text.isEmpty || _paymentImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and upload payment proof.')),
      );
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    bool success = await bookingProvider.createBooking(
      userId: auth.user!.id,
      userName: auth.user!.name,
      phone: auth.user!.phone,
      checkIn: _checkIn!,
      checkOut: _checkOut!,
      guestName: _guestNameController.text.trim(),
      roomType: _selectedRoomType,
      paymentImage: _paymentImage,
    );

    if (success && mounted) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 60),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Request Submitted!', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 10),
            const Text('Booking request added successfully for the guest.', textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Manual Booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Room Selection'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedRoomType,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRoomType = newValue!;
                    });
                  },
                  items: _roomTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionHeader('Stay Dates'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildDateTile('Check-in', _checkIn, true)),
                const SizedBox(width: 16),
                Expanded(child: _buildDateTile('Check-out', _checkOut, false)),
              ],
            ),
            const SizedBox(height: 30),
            _buildSectionHeader('Guest Information'),
            const SizedBox(height: 10),
            TextField(
              controller: _guestNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name of Guest',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionHeader('Payment Screenshot'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Column(
                children: [
                  _paymentImage == null
                      ? ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.cloud_upload_outlined),
                          label: const Text('Upload Receipt'),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
                        )
                      : Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_paymentImage!, height: 150, width: double.infinity, fit: BoxFit.cover),
                            ),
                            TextButton.icon(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.edit),
                              label: const Text('Change Image'),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: Consumer<BookingProvider>(
                builder: (context, provider, _) {
                  return provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFB300),
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('CREATE BOOKING'),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1A237E)),
    );
  }

  Widget _buildDateTile(String label, DateTime? date, bool isCheckIn) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (selectedDate != null) {
          setState(() {
            if (isCheckIn) {
              _checkIn = selectedDate;
            } else {
              _checkOut = selectedDate;
            }
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text(
              date == null ? 'Select' : DateFormat('MMM dd, yyyy').format(date),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
