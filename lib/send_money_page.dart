import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobile_bank_app/widgets/custom_button.dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Bank App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.teal, fontSize: 16),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
        ),
      ),
      home: const SendMoneyPage(),
    );
  }
}

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _formKey = GlobalKey<FormState>();
  String _recipientName = '';
  double _amount = 0;
  String? _selectedPaymentMethod;
  bool _isFavorite = false;
  bool _isTransactionSuccessful = false;

  final List<String> _paymentMethods = ['Credit Card', 'Debit Card', 'PayPal'];

  void _sendMoney() {
    if (_formKey.currentState?.validate() ?? false) {
      log('Recipient: $_recipientName');
      log('Amount: $_amount');
      log('Payment Method: $_selectedPaymentMethod');
      log('Marked as Favorite: $_isFavorite');

      setState(() {
        _isTransactionSuccessful = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isTransactionSuccessful = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Recipient Name',
                  prefixIcon: Icon(Icons.person, color: Colors.teal),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipient name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _recipientName = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money, color: Colors.teal),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid positive amount';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _amount = double.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                ),
                items: _paymentMethods.map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a payment method';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Mark as Favorite',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  Switch(
                    value: _isFavorite,
                    onChanged: (value) {
                      setState(() {
                        _isFavorite = value;
                      });
                    },
                    activeColor: Colors.teal,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: CustomButton(
                  text: 'Send Money',
                  onPressed: _sendMoney,
                ),
              ),
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _isTransactionSuccessful ? 50 : 0,
                child: _isTransactionSuccessful
                    ? Container(
                        width: double.infinity,
                        color: Colors.green,
                        child: const Center(
                          child: Text(
                            'Transaction Successful!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
