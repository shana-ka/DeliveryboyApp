class Order {
  final String orderId;
  final String customerName;
  final String address;
  final String deliveryTime;
  final double distance;
  final String status;
  final String? deliveredDate;

  Order({
    required this.orderId,
    required this.customerName,
    required this.address,
    required this.deliveryTime,
    required this.distance,
    required this.status,
    this.deliveredDate,
  });

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'customerName': customerName,
    'address': address,
    'deliveryTime': deliveryTime,
    'distance': distance,
    'status': status,
    'deliveredDate': deliveredDate,
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    orderId: json['orderId'],
    customerName: json['customerName'],
    address: json['address'],
    deliveryTime: json['deliveryTime'],
    distance: json['distance'].toDouble(),
    status: json['status'],
    deliveredDate: json['deliveredDate'],
  );

  static List<Order> getDummyOrders() {
    return [
      Order(
        orderId: 'ORD001',
        customerName: 'Ravi Kumar',
        address: 'TC 15/234, Pattom, Thiruvananthapuram, Kerala 695004',
        deliveryTime: '2:30 PM',
        distance: 2.5,
        status: 'Pending',
      ),
      Order(
        orderId: 'ORD002',
        customerName: 'Priya Nair',
        address: 'House No 42, MG Road, Ernakulam, Kochi, Kerala 682016',
        deliveryTime: '3:15 PM',
        distance: 1.8,
        status: 'In Transit',
      ),
      Order(
        orderId: 'ORD003',
        customerName: 'Suresh Menon',
        address: 'Flat 3B, Calicut Tower, Mavoor Road, Kozhikode, Kerala 673004',
        deliveryTime: '4:00 PM',
        distance: 4.2,
        status: 'Pending',
      ),
      Order(
        orderId: 'ORD004',
        customerName: 'Anjali Pillai',
        address: 'Villa 12, Kadavanthra, Ernakulam, Kochi, Kerala 682020',
        deliveryTime: '4:45 PM',
        distance: 3.1,
        status: 'Pending',
      ),
    ];
  }
}