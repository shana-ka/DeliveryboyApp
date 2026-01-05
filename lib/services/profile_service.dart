import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _nameKey = 'profile_name';
  static const String _emailKey = 'profile_email';
  static const String _vehicleKey = 'profile_vehicle';
  static const String _licenseKey = 'profile_license';

  static Future<void> saveProfile({
    required String name,
    required String email,
    required String vehicle,
    required String license,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_vehicleKey, vehicle);
    await prefs.setString(_licenseKey, license);
  }

  static Future<Map<String, String>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_nameKey) ?? 'Arjun Nair',
      'email': prefs.getString(_emailKey) ?? 'arjun.nair@delivery.com',
      'vehicle': prefs.getString(_vehicleKey) ?? 'Motorcycle',
      'license': prefs.getString(_licenseKey) ?? 'KL0720230001234',
    };
  }
}