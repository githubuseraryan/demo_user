import 'dart:developer';

import 'package:demo_project_user/screens/CheckoutPage.dart';
import 'package:demo_project_user/utils/Commonmethods.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'DetailsPage.dart';

class ServiceItem {
  final String name;
  final int price;
  final String time;
  final String clientName;

  ServiceItem({
    required this.name,
    required this.price,
    required this.time,
    required this.clientName,
  });
}

class AllServicesPage extends StatefulWidget {
  final String userEmail;

  AllServicesPage({required this.userEmail});

  @override
  _AllServicesPageState createState() => _AllServicesPageState();
}

class _AllServicesPageState extends State<AllServicesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _addToCart(String name, int price, ServiceItem service) {
    // final service = ServiceItem(
    //   name: name,
    //   price: price,
    //   time: DateTime.now().millisecondsSinceEpoch,
    //   clientName: widget.userEmail,
    // );
    setState(() {
      commonMethods.cart.add(service);
      log('All log add p${service.price} :::${service.name} :::${service.time} :::${service.clientName} :::');

     // commonMethods._cart.add(service);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Added to cart! Total: \₹${commonMethods.cart.fold(0, (sum, item) => sum + item.price)}'),
    ));
  }

  void _removeFromCart( String name, int price, ServiceItem service ) {
    // final service = ServiceItem(
    //   name: name,
    //   price: price,
    //   time: DateTime.now().millisecondsSinceEpoch,
    //   clientName: widget.userEmail,
    // );
    log('All log remove p${service.price} :::${service.name} :::${service.time} :::${service.clientName} :::');

    setState(() {
      // commonMethods.cart.removeWhere(s =>  s.hashCode == service.hashCode)   ;
      var item =  commonMethods.cart.firstWhere((x) => x.name== service.name && x.price== service.price, orElse: () => service);
commonMethods.cart.remove(item);
    });
    log('All log after remove p${service.price} :::${service.name} :::${service.time} :::${service.clientName} :::');
    log('All log after remove'+commonMethods.cart.length.toString());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Removed from cart. Total: \₹${commonMethods.cart.fold(0, (sum, item) => sum + item.price)}'),
    ));
  }

  List<Widget> _buildServiceList(String serviceType) {
    final services = {
      'AC Repair': [
        {'name': 'AC Full clean only', 'price': 600},
        {'name': 'AC Deep clean', 'price': 700},
        {'name': 'AC Deep clean with service', 'price': 800},
      ],
      'Refrigerator Repair': [
        {'name': 'Refrigerator Full clean only', 'price': 500},
        {'name': 'Refrigerator Deep clean', 'price': 600},
        {'name': 'Refrigerator Deep clean with service', 'price': 700},
      ],
      'Fan Repair': [
        {'name': 'Fan Full clean only', 'price': 400},
        {'name': 'Fan Deep clean', 'price': 500},
        {'name': 'Fan Deep clean with service', 'price': 600},
      ],
    };

    return services[serviceType]!.map((item) {
      final service = ServiceItem(
        name: item['name']!.toString(),
        price: int.parse(item['price']!.toString()),
        time: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        clientName: widget.userEmail,
      );

      return ListTile(
        title: GestureDetector(child: Text("${item['name']!}"),onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(
                name: service.name,
                price: service.price,
                clientName: service.clientName,
              ),
            ),
          );
        },),
        subtitle: Text('Price: \₹${item['price']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => _addToCart(service.name, service.price, service),
              child: Text('Add to Cart'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _removeFromCart(service.name, service.price, service),
              child: Text('Remove'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Services'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
        ],
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Welcome, ${widget.userEmail}',
                style: TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CheckoutPage(cart: commonMethods.cart,userEmail: widget.userEmail,)
                    ),
                  );
                },
                child: Text('Check out'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
              )
            ],
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'AC Repair'),
              Tab(text: 'Refrigerator Repair'),
              Tab(text: 'Fan Repair'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(children: _buildServiceList('AC Repair')),
                ListView(children: _buildServiceList('Refrigerator Repair')),
                ListView(children: _buildServiceList('Fan Repair')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
