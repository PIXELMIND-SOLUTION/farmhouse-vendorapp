class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'http://31.97.206.144:5124/api';

  // Vendor Endpoints
  static const String vendorLogin = '$baseUrl/vendor/login';
  static const String getallfarmhouse='$baseUrl/farmhouse/farmhouseId';
  // Headers
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Map<String, String> authHeaders(String token) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
}