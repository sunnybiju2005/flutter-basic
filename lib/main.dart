import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
    
    // Initialize notifications
    await NotificationService().init();
  } catch (e) {
    print("CRITICAL: Firebase initialization failed: $e");
    // We keep running the app, but providers will fail if they touch Firebase
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        title: 'GK Residency Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A237E),
            primary: const Color(0xFF1A237E),
            secondary: const Color(0xFFFFB300),
            surface: Colors.white,
          ),
          textTheme: GoogleFonts.outfitTextTheme(),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
