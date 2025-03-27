import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 18, color: Colors.black),
              text: "Total Expenses \n(in the month of March) ",
              children: [
                TextSpan(
                  text: "Rs. 10,000",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(),
          const Text("Total Savings \n(in the month of March) "),
          const Text("Rs. 10,000"),
        ],
      ),
    );
  }
}
