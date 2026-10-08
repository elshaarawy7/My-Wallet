import 'package:flutter/widgets.dart';

class TransactionPageBody extends StatefulWidget {
  const TransactionPageBody({super.key});

  @override
  State<TransactionPageBody> createState() => _TransactionPageBodyState();
}

class _TransactionPageBodyState extends State<TransactionPageBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "معاملاتي",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Add your form fields and buttons here
        ],
      ),
    );
  }
}