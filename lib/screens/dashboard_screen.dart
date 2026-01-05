import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';
import 'mobile_login_screen.dart';
import 'order_details_screen.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String deliveryBoyName = 'Arjun Nair';
  String ord001Status = 'Pending';
  String ord002Status = 'In Transit';
  String ord003Status = 'Pending';
  String ord004Status = 'Pending';

  @override
  void initState() {
    super.initState();
  }

  void logout() async {
    await AuthService.clearSession();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MobileLoginScreen()),
      );
    }
  }

  void openOrderDetails(String orderId, String customerName, String address, String time, String distance, String status) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(
          orderId: orderId,
          customerName: customerName,
          address: address,
          time: time,
          distance: distance,
          status: status,
        ),
      ),
    );
    
    if (result != null && result is Map && result['orderId'] != null && result['status'] != null) {
      setState(() {
        String orderIdResult = result['orderId'] as String;
        String statusResult = result['status'] as String;
        if (orderIdResult == 'ORD001') ord001Status = statusResult;
        if (orderIdResult == 'ORD002') ord002Status = statusResult;
        if (orderIdResult == 'ORD003') ord003Status = statusResult;
        if (orderIdResult == 'ORD004') ord004Status = statusResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
              );
            },
            icon: const Icon(Icons.history),
          ),
          Consumer<ThemeService>(
            builder: (context, themeService, child) {
              return IconButton(
                onPressed: themeService.toggleTheme,
                icon: Icon(
                  themeService.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                const Icon(Icons.delivery_dining, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Welcome $deliveryBoyName',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                const Text(
                  '4 Orders',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                orderCard('ORD001', 'Ravi Kumar', 'TC 15/234, Pattom, Thiruvananthapuram, Kerala 695004', '2:30 PM', '2.5 km', ord001Status),
                orderCard('ORD002', 'Priya Nair', 'House No 42, MG Road, Ernakulam, Kochi, Kerala 682016', '3:15 PM', '1.8 km', ord002Status),
                orderCard('ORD003', 'Suresh Menon', 'Flat 3B, Calicut Tower, Mavoor Road, Kozhikode, Kerala 673004', '4:00 PM', '4.2 km', ord003Status),
                orderCard('ORD004', 'Anjali Pillai', 'Villa 12, Kadavanthra, Ernakulam, Kochi, Kerala 682020', '4:45 PM', '3.1 km', ord004Status),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget orderCard(String orderId, String customerName, String address, String time, String distance, String status) {
    String safeStatus = (status == null || status == 'undefined') ? 'Pending' : status;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => openOrderDetails(orderId, customerName, address, time, distance, safeStatus),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    orderId,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: safeStatus == 'Delivered' ? Colors.green : 
                             safeStatus == 'In Transit' ? Colors.blue : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      safeStatus,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(customerName),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(child: Text(address)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(time, style: const TextStyle(color: Colors.blue)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.directions, size: 16, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(distance, style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}