import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/features/home/controller/expense_controller.dart';

class AddExpense extends ConsumerStatefulWidget {
  const AddExpense({super.key});
  @override
  ConsumerState<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends ConsumerState<AddExpense> {
  DateTime? selectedDate;
  int _value = 0;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List categories = [
    "Food",
    "Transportation",
    "Shopping",
    "Entertainment",
    "Other",
  ];

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    setState(() {
      selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Add Expense'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ExpenseWidget(
              controller: _amountController,
              isNumber: true,
              label: "Amount (INR)",
            ),
            ExpenseWidget(
              controller: _descriptionController,
              isNumber: false,
              label: "Description",
            ),
            const SizedBox(height: 10),
            const Text(
              "Category",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 5.0,
              children: List<Widget>.generate(5, (int index) {
                return ChoiceChip(
                  showCheckmark: false,
                  selectedColor: const Color.fromARGB(255, 101, 206, 171),
                  label: Text(categories[index]),
                  selected: _value == index,
                  onSelected: (bool selected) {
                    setState(() {
                      _value = (selected ? index : null)!;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            const Text(
              "Date",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _selectDate,
              child: Text(
                selectedDate == null
                    ? 'Select Date'
                    : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              height: 1,
              color: Colors.black45,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'Add',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (_amountController.text.isNotEmpty &&
                _descriptionController.text.isNotEmpty &&
                selectedDate != null) {
              ref.read(expenseControllerProvider.notifier).addExpense(
                  context: context,
                  amount: int.parse(_amountController.text),
                  description: _descriptionController.text,
                  category: categories[_value],
                  dateTime: selectedDate!);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('All fields are required'),
                ),
              );
            }
          },
        )
      ],
    );
  }
}

class ExpenseWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isNumber;
  const ExpenseWidget({
    required this.controller,
    required this.isNumber,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
