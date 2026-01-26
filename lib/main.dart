import 'package:bkash/bkash.dart';
import 'package:flutter/material.dart';
import 'package:uddoktapay/models/customer_model.dart';
import 'package:uddoktapay/models/request_response.dart';
import 'package:uddoktapay/uddoktapay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> paymentMethod = ['bkash', 'nagad','uddoktapay','sslcommerz', 'razorpay'];

  String? selectedMethod;

  double amount = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Select Payment Method',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // -------- Payment Buttons --------
            Expanded(
              child: ListView.separated(
                itemCount: paymentMethod.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final method = paymentMethod[index];
                  final isSelected = selectedMethod == method;

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Colors.pinkAccent
                          : Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedMethod = method;
                      });
                    },
                    child: Text(
                      method.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),

            // -------- Pay Now Button --------
            if (selectedMethod != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    onPayNow(selectedMethod!);
                  },
                  child: Text(
                    'Pay Now with ${selectedMethod!}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  //-------- Payment Handler --------

  void onPayNow(String method) {
    switch (method) {
      case 'bkash':
        bKashPayment(context);
        break;
      case 'nagad':
        debugPrint('Nagad payment called');
        break;
      case 'sslcommerz':
        debugPrint('SSLCommerz payment called');
        break;
      case 'razorpay':
        debugPrint('Razorpay payment called');
        break;
        case 'uddoktapay':
          uddoktaPay(context);
        break;
    }
  }

  final bKash = Bkash(
    /*
    // if you have if credential with bkash merchant number then remove the comment and fill this
    bkashCredentials: BkashCredentials(
      isSandbox: false,

      username: username,
      password: password,
      appKey: appKey,
      appSecret: appSecret,


    ),

    */
    logResponse: true,
  );

  void bKashPayment(BuildContext context) async {
    try {
      final response = await bKash.pay(
        context: context,
        amount: amount,
        merchantInvoiceNumber: '01',
      );

      print(response.merchantInvoiceNumber);
      print(response.customerMsisdn);
      print(response.payerReference);
      print(response.paymentId);
      print(response.trxId);
    } on BkashFailure catch (e) {
      print('Payment : ==========>>>>>>>$e');
    }
  }

  //this one for uddokta pay

  void uddoktaPay(BuildContext context) async {
    try {
     final response= UddoktaPay.createPayment(
        context: context,
        customer: CustomerDetails(
          fullName: 'Programming Wormhole',
          email: 'programmingwormhole@icloud.com',
        ),
        amount: amount.toString(),
      );


     print(response);

    } catch (e) {
      print('Payment : ==========>>>>>>>$e');
    }
  }


}
