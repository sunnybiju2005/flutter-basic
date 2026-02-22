import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  // Hardcoded Admin user so the app doesn't require login
  AppUser? _user = AppUser(
    id: 'admin_fixed',
    name: 'Admin',
    email: 'admin@gkresidency.com',
    phone: '0000000000',
    isAdmin: true,
  );
  
  bool _isLoading = false;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider() {
    // No login required for admin app
  }

  // Auth methods remain as placeholders or for manual switching if ever needed
  Future<bool> login(String email, String password) async {
    return true; 
  }

  Future<bool> register(String email, String password, String name, String phone) async {
    return true;
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }
}
