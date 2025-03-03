import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'AllServicesPage.dart';



class CheckoutPage extends StatefulWidget {
  final List<ServiceItem> cart;
  final String userEmail;

  CheckoutPage({required this.cart, required this.userEmail});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  int getTotalPrice() {
    return widget.cart.fold(0, (sum, item) => sum + item.price);
  }

  Future<void> _payNow() async {
    final total = getTotalPrice();
    final services = widget.cart.map((item) => item.name).join(', ');
    final email = widget.userEmail;
    final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final timeSec = DateTime.now().millisecondsSinceEpoch;

    if(_addressController.text.isNotEmpty ){
      if(total > 0){
        try {
          await _firestore.collection('Orders').add({
            'total': total,
            'services': services,
            'email': email,
            'date': date,
            'address': _addressController.text,
            'timeSec': timeSec,
            'completed': false,
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Order placed successfully!'),
          ));
          _addressController.text = "";
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to place order: $e'),
          ));
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Add item to cart'),
        ));
      }

}else{
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Fill address'),
  ));
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Out'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total services: ${widget.cart.map((item) => item.name).join(', ')}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total Items: ${widget.cart.length}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total Price: ₹${getTotalPrice()}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _payNow,
                child: Text('Pay Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
