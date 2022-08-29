import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urwaypayment/urwaypayment.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> makePayment() async {

    // To store payment data
    dynamic lastResult;


    try {

      // initiate payment
      lastResult = await Payment.makepaymentService(context: context,
          country: "SA",
          action: "1",
          currency: "SAR",
          amt: "1.00",
          customerEmail: "john.deo@gmail.com",
          trackid: "111AAA",
          udf1: "",
          udf2: "",
          udf3: "",
          udf4: "",
          udf5: "",
          cardToken: "",
          address: "ABC",
          city: "PQR",
          state: "XYZ",
          tokenizationType: "1",
          zipCode: "",
          tokenOperation: "A/U/D");


      print('Result in Main is $lastResult');
      
    } on PlatformException {
      print('Failed payment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Test'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Waiting for Response.'),
            RaisedButton(
              child: Text('Call payment'),
              onPressed: () => makePayment(),
            )
          ],
        )),
      ),
    );
  }
}
