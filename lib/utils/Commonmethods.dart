import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/AllServicesPage.dart';

class commonMethods{

  static List<ServiceItem> cart = [];

  static showSnackBar2 (BuildContext context,String message){
    final snackBar = SnackBar(
      content:  Text(message),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
          print("UNDO 5678");
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
}