import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Session extends ChangeNotifier {
  Session._();
  static final Session instance = Session._();

  static const _storage = FlutterSecureStorage();
  static const _jwtKey = 'jwt';

  String? _token;
  String? get token => _token;

  Future<bool> hasToken() async {
    _token ??= await _storage.read(key: _jwtKey);
    return _token != null && _token!.isNotEmpty;
  }

  Future<void> saveToken(String token) async {
    _token = token;
    await _storage.write(key: _jwtKey, value: token);
    notifyListeners();
  }

  Future<void> clear() async {
    _token = null;
    await _storage.delete(key: _jwtKey);
    notifyListeners();
  }
}
