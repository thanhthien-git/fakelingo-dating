import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fakelingo/core/services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  bool _isLoading = true;

  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _token != null;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    _isLoading = true;
    notifyListeners();

    _token = StorageService.getToken();

    final valid = await this.isTokenValid(_token);
    if (!valid) {
      _token = null;
      StorageService.clearToken();
    }

    _isLoading = false;
    notifyListeners();
  }

  Map<String, dynamic>? decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;

    try {
      final payload = parts[1];
      final normalized = base64.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded);

      StorageService.setItem('user_id', payloadMap['userId']);
      StorageService.setItem('user_name', payloadMap['userName']);

      return payloadMap is Map<String, dynamic> ? payloadMap : null;
    } catch (e) {
      print('Decode error: $e');
      return null;
    }
  }

  Future<bool> isTokenValid(String? token) async {
    if (token == null || token.isEmpty) return false;

    final payload = decodeJwtPayload(token);
    if (payload == null) return false;

    final exp = payload['exp'];
    if (exp == null) return false;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    final now = DateTime.now();

    print('Decoded JWT Payload: $payload');
    print('Token expires at: $expiryDate');
    print('Current time: $now');

    return now.isBefore(expiryDate);
  }

  Future<void> login(String token) async {
    _token = token;
    StorageService.saveToken(token);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    StorageService.clearToken();
    notifyListeners();
  }
}
