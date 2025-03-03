import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/Commonmethods.dart';
import 'AllServicesPage.dart';

class DetailsPage extends StatefulWidget {
  final String name;
  final int price;
  final String clientName;

  DetailsPage({
    required this.name,
    required this.price,
    required this.clientName,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String getServiceDescription() {
    switch (widget.name) {
      case 'Full clean only':
        return 'This service includes a thorough cleaning of the external and internal components of your appliance. It removes dust, dirt, and other contaminants that can affect performance. The service ensures that all parts are spotless and functioning properly, providing an immediate improvement in efficiency.';
      case 'Deep clean':
        return 'Going beyond the standard cleaning, the Deep Clean service targets hard-to-reach areas and components within your appliance. This includes cleaning the internal mechanisms, filters, and other critical parts. It helps in preventing potential breakdowns, improving the longevity and performance of your appliance.';
      case 'Deep clean with maintenance':
        return 'This comprehensive service combines a deep clean with essential maintenance tasks. Along with the thorough cleaning of all parts, the service includes checking and replacing worn-out components, lubricating moving parts, and ensuring everything is in optimal working condition. It aims to keep your appliance running smoothly and efficiently, minimizing the risk of future issues.';
      default:
        return '';
    }
  }

  void _addToCart(BuildContext context) {
    final service = ServiceItem(
      name: widget.name,
      price: widget.price,
      time: DateFormat('dd/MM/yyyy').format(DateTime.now()),

      clientName: widget.clientName,
    );
    setState(() {
      commonMethods.cart.add(service);

      // commonMethods._cart.add(service);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Added to cart! Total: \₹${commonMethods.cart.fold(0, (sum, item) => sum + item.price)}'),
    ));
  }

  void _removeFromCart(BuildContext context) {
    final service = ServiceItem(
      name: widget.name,
      price: widget.price,
      time: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      clientName: widget.clientName,
    );
    setState(() {
      if(commonMethods.cart.isNotEmpty){
        commonMethods.cart.remove(service);

      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Removed from cart.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              'https://cdn.pixabay.com/photo/2021/12/14/07/34/worker-6869868_960_720.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(getServiceDescription()),
            SizedBox(height: 20),
            Text(
              'Price: ₹${widget.price}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment:  MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _addToCart(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen),
                  child: const Text('Add to Cart'),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () => _removeFromCart(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  child: const Text('Remove'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
