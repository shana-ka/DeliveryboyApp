import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

class OrderHistoryService {
  static const String _historyKey = 'order_history';

  static Future<void> addDeliveredOrder(Order order) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyKey) ?? '[]';
    final List<dynamic> history = json.decode(historyJson);
    
    final deliveredOrder = Order(
      orderId: order.orderId,
      customerName: order.customerName,
      address: order.address,
      deliveryTime: order.deliveryTime,
      distance: order.distance,
      status: 'Delivered',
      deliveredDate: DateTime.now().toString(),
    );
    
    history.add(deliveredOrder.toJson());
    await prefs.setString(_historyKey, json.encode(history));
  }

  static Future<List<Order>> getDeliveredOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyKey) ?? '[]';
    final List<dynamic> history = json.decode(historyJson);
    
    return history.map((json) => Order.fromJson(json)).toList()
        .where((order) => order.status == 'Delivered')
        .toList()
        ..sort((a, b) => DateTime.parse(b.deliveredDate!).compareTo(DateTime.parse(a.deliveredDate!)));
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}