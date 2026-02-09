import 'package:flutter/material.dart';
import '../models/app_user.dart';

class AuthProvider extends ChangeNotifier {
  // Directly set the admin user to bypass login
  AppUser? _user = AppUser(
    id: "admin_1",
    name: "GK Admin",
    email: "admin@gk.com",
    phone: "9876543210",
    isAdmin: true,
  );
  
  bool _isLoading = false;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    return true; 
  }

  Future<void> logout() async {
    // Optionally keep it simple or allow logout if you want to switch views later
    _user = null;
    notifyListeners();
  }
}
