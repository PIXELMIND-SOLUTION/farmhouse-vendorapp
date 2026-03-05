import 'dart:convert';
import 'package:farmhouse_vendor/constant/api_constant.dart';
import 'package:farmhouse_vendor/model/vendor_model.dart';
import 'package:http/http.dart' as http;

class VendorService {
  VendorService._();

  static final VendorService instance = VendorService._();

  // ─── Vendor Login ────────────────────────────────────────────────────────────

  Future<VendorLoginResponse> login({
    required String name,
    required String password,
  }) async {
    try {
      final request = VendorLoginRequest(name: name, password: password);

      final response = await http.post(
        Uri.parse(ApiConstants.vendorLogin),
        headers: ApiConstants.headers,
        body: jsonEncode(request.toJson()),
      );

      // Use utf8.decode to safely handle large/unicode response bodies
      final String rawBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> responseBody = jsonDecode(rawBody);

      print('Response status code for vendor login ${response.statusCode}');
      print('Response bodyyyyyyyyyyyyyyy for vendor login ${response.body}');

      if (response.statusCode == 200) {
        return VendorLoginResponse.fromJson(responseBody);
      } else {
        throw ServiceException(
          message: responseBody['message'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } on ServiceException {
      rethrow;
    } on FormatException catch (e) {
      throw ServiceException(message: 'Invalid response format: $e');
    } catch (e) {
      throw ServiceException(message: 'Something went wrong: $e');
    }
  }
}

// ─── Service Exception ────────────────────────────────────────────────────────

class ServiceException implements Exception {
  final String message;
  final int? statusCode;

  ServiceException({required this.message, this.statusCode});

  @override
  String toString() => 'ServiceException: $message (status: $statusCode)';
}
