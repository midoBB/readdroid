import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = true;

  String? _token;
  String? _serverAddress;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _serverKey = 'server_address';

  AuthProvider() {
    _loadCredentials();
  }

  bool get isLoading => _isLoading;

  Future<void> _loadCredentials() async {
    _isLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _serverAddress = prefs.getString(_serverKey);
    _token = await _storage.read(key: _tokenKey);
    _isLoading = false;
    notifyListeners();
  }

  String? get token => _token;
  String? get serverAddress => _serverAddress;
  bool get isAuthenticated => _token != null && _serverAddress != null;

  Future<void> setAuthenticated(String token, String serverAddress) async {
    _token = token;
    _serverAddress = serverAddress;
    await _storage.write(key: _tokenKey, value: token);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_serverKey, serverAddress);
    notifyListeners();
  }

  Future<void> setUnauthenticated() async {
    _token = null;
    await _storage.delete(key: _tokenKey);
    notifyListeners();
  }
}
