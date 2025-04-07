import 'package:flutter/material.dart';

class EditBudgetScreen extends StatelessWidget {
  final budgetNameController = TextEditingController(text: 'Grocery Budget');
  final dateController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Edit Budget'), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(
              'Gegg',
              style: theme.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              'Budget',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: budgetNameController,
              decoration: const InputDecoration(labelText: 'Budget Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Save New Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
