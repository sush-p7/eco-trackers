import 'package:flutter/material.dart';
import 'package:fourth_app/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addOnExpense});
  final void Function(Expense expense) addOnExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leaisure;

  void _datePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        firstDate: firstDate,
        initialDate: now,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitFormData() {
    final amount = double.tryParse(
        _amountController.text); //try parse return null if text is not valid
    final amountIsInvlid = amount == null || amount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvlid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Invalid Input'),
              content: const Text(
                  'Please make sure a valid title , amount and Date Enterd'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'))
              ],
            );
          });
      return;
    }
    //..
    Expense expense = Expense(
      title: _titleController.text,
      price: amount,
      date: _selectedDate!,
      category: _selectedCategory,
      id: uuid.v4(),
    );
    widget.addOnExpense(expense);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      child: Column(
        children: [
          TextField(
            maxLength: 50,
            decoration: const InputDecoration(label: Text('Title')),
            controller: _titleController,
          ),
          Row(children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                    label: Text('Amount'), prefixText: '\$'),
                controller: _amountController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Text(_selectedDate == null
                      ? 'No Date selected'
                      : formater.format(_selectedDate!)),
                  IconButton(
                      onPressed: _datePicker,
                      icon: const Icon(Icons.calendar_month))
                ])),
          ]),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = value;
                    });
                  }),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                  onPressed: _submitFormData,
                  child: const Text('Save Expense')),
            ],
          )
        ],
      ),
    );
  }
}
