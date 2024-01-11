import 'package:flutter/material.dart';
import 'package:zamzuma/widgets/chart/chart.dart';
import 'package:zamzuma/widgets/expenses_list/expenses_list.dart';
import 'package:zamzuma/models/expense.dart';
import 'package:zamzuma/widgets/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      amount: 20,
      title: "yarru",
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      amount: 10,
      title: "mertbaba",
      date: DateTime.now(),
      category: Category.travel,
    )
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      
        context: context,
        builder: (ctx) => NewExpense(
              onAddExpense: _addNewExpense,
            ),
        isScrollControlled: true
        );
  }

  void _addNewExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpenses(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          }),
        ),
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted!')));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        removeExpense: _removeExpenses,
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Expense Tracker"),
          actions: [
            IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: width < 500
            ? Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  Expanded(
                    child: mainContent,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  Expanded(
                    child: mainContent,
                  ),
                ],
              ));
  }
}
