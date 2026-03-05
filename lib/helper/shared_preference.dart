import 'dart:convert';
import 'package:farmhouse_vendor/model/vendor_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  SharedPrefHelper._();

  static const String _keyVendor = 'vendor_data';
  static const String _keyFarmhouse = 'farmhouse_data';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyVendorName = 'vendor_name';

  // ─── Save Login Data ────────────────────────────────────────────────────────

  static Future<void> saveLoginData(VendorLoginResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyVendor, jsonEncode(response.vendor.toJson()));
    await prefs.setString(_keyFarmhouse, jsonEncode(response.farmhouse.toJson()));
    await prefs.setString(_keyVendorName, response.vendor.name);
  }

  // ─── Get Vendor ─────────────────────────────────────────────────────────────

  static Future<VendorModel?> getVendor() async {
    final prefs = await SharedPreferences.getInstance();
    final vendorJson = prefs.getString(_keyVendor);
    if (vendorJson == null) return null;
    return VendorModel.fromJson(jsonDecode(vendorJson));
  }

  // ─── Get Farmhouse ──────────────────────────────────────────────────────────

  static Future<FarmhouseModel?> getFarmhouse() async {
    final prefs = await SharedPreferences.getInstance();
    final farmhouseJson = prefs.getString(_keyFarmhouse);
    if (farmhouseJson == null) return null;
    return FarmhouseModel.fromJson(jsonDecode(farmhouseJson));
  }

  // ─── Is Logged In ────────────────────────────────────────────────────────────

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // ─── Get Vendor Name ────────────────────────────────────────────────────────

  static Future<String?> getVendorName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyVendorName);
  }

  // ─── Clear All (Logout) ──────────────────────────────────────────────────────

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}