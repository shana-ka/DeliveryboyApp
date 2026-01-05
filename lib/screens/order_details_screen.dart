import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'location_tracking_screen.dart';
import '../services/order_history_service.dart';
import '../models/order.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  final String customerName;
  final String address;
  final String time;
  final String distance;
  final String? status;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.address,
    required this.time,
    required this.distance,
    this.status,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String currentStatus = '';
  bool isDelivering = false;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.status ?? 'Pending';
  }

  String getCustomerPhone() {
    switch (widget.orderId) {
      case 'ORD001':
        return '+91 98765 43210';
      case 'ORD002':
        return '+91 87654 32109';
      case 'ORD003':
        return '+91 76543 21098';
      case 'ORD004':
        return '+91 65432 10987';
      default:
        return '+91 98765 43210';
    }
  }

  void markAsDelivered() async {
    setState(() => isDelivering = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Save to order history
    final order = Order(
      orderId: widget.orderId,
      customerName: widget.customerName,
      address: widget.address,
      deliveryTime: widget.time,
      distance: double.parse(widget.distance.replaceAll(' km', '')),
      status: 'Delivered',
    );
    await OrderHistoryService.addDeliveredOrder(order);
    
    setState(() {
      currentStatus = 'Delivered';
      isDelivering = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order marked as delivered!')),
    );
    
    // Return updated status to dashboard
    Navigator.pop(context, {'orderId': widget.orderId, 'status': 'Delivered'});
  }

  void makeCall() async {
    final phoneNumber = getCustomerPhone().replaceAll(' ', '');
    final uri = Uri.parse('tel:$phoneNumber');
    
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone calling not supported on this platform')),
        );
      }
    }
  }

  void openNavigation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationTrackingScreen(
          customerAddress: widget.address,
          orderId: widget.orderId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${widget.orderId}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: currentStatus == 'Delivered' ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Status: $currentStatus',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Customer Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Customer Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(widget.customerName, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(child: Text(widget.address, style: const TextStyle(fontSize: 16))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(getCustomerPhone(), style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('${widget.time} • ${widget.distance}', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Products List
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    productItem('Pizza Margherita', '2x', '\$24.99'),
                    productItem('Coca Cola', '1x', '\$3.99'),
                    productItem('Garlic Bread', '1x', '\$5.99'),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('\$34.97', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Map Placeholder
            Card(
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 60, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Customer Location Map', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: makeCall,
                    icon: const Icon(Icons.phone),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: openNavigation,
                    icon: const Icon(Icons.navigation),
                    label: const Text('Navigate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Mark as Delivered Button
            if (currentStatus != 'Delivered')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isDelivering ? null : markAsDelivered,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isDelivering
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Mark as Delivered', style: TextStyle(fontSize: 16)),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Order Delivered',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget productItem(String name, String quantity, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(name)),
          Text(quantity, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 16),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}