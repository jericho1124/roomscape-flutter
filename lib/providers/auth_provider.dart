import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  // Initialize the auth state
  Future<void> initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    _user = await FirebaseService.getCurrentUser();

    _isLoading = false;
    notifyListeners();
  }

  // Sign in with email
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      _user = await FirebaseService.signInWithEmail(email, password);
      
      _isLoading = false;
      notifyListeners();
      
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      _user = await FirebaseService.signInWithGoogle();
      
      _isLoading = false;
      notifyListeners();
      
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Sign up with email
  Future<bool> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      _user = await FirebaseService.signUpWithEmail(email, password, name);
      
      _isLoading = false;
      notifyListeners();
      
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await FirebaseService.signOut();
      _user = null;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_user != null) {
        final success = await FirebaseService.updateUserProfile(_user!.id, data);
        if (success) {
          _user = _user!.copyWith(
            name: data['name'] ?? _user!.name,
            photoUrl: data['photoUrl'] ?? _user!.photoUrl,
            shippingAddress: data['shippingAddress'] ?? _user!.shippingAddress,
          );
        }
        
        _isLoading = false;
        notifyListeners();
        
        return success;
      }
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
} 