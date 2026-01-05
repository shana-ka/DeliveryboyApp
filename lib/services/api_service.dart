import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.deliveryboy.com';
  
  // Mock login API
  static Future<Map<String, dynamic>> login(String phoneNumber, String otp) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Load mock response from JSON file
    final String response = await rootBundle.loadString('assets/mock_data/login_response.json');
    return json.decode(response);
  }
  
  // Mock fetch orders API
  static Future<Map<String, dynamic>> fetchOrders() async {
    await Future.delayed(const Duration(seconds: 1));
    
    final String response = await rootBundle.loadString('assets/mock_data/orders_response.json');
    return json.decode(response);
  }
  
  // Mock update order status API
  static Future<Map<String, dynamic>> updateOrderStatus(String orderId, String status) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final String response = await rootBundle.loadString('assets/mock_data/update_status_response.json');
    final Map<String, dynamic> data = json.decode(response);
    
    // Update with actual values
    data['data']['orderId'] = orderId;
    data['data']['status'] = status;
    data['data']['updatedAt'] = DateTime.now().toIso8601String();
    
    return data;
  }
  
  // Mock fetch profile API
  static Future<Map<String, dynamic>> fetchProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    
    final String response = await rootBundle.loadString('assets/mock_data/profile_response.json');
    return json.decode(response);
  }
  
  // Real API call example (commented out)
  /*
  static Future<Map<String, dynamic>> realApiCall(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: body != null ? json.encode(body) : null,
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
  */
}