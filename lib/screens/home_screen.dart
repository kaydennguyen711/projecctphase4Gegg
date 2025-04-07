import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String budgetName = 'Grocery Budget';
  String budgetDate = 'March 25, 2025';
  String budgetAmount = '\$1000.00';
  String budgetLeft = '\$1000.00';

  // List of available budgets with their amounts
  Map<String, double> budgets = {
    'Grocery Budget': 1000.00,
    'Entertainment Budget': 500.00,
    'Transportation Budget': 300.00,
    'Utilities Budget': 200.00,
    'Shopping Budget': 400.00,
  };

  // Map to store spent amounts for each budget
  Map<String, double> spentAmounts = {
    'Grocery Budget': 0.00,
    'Entertainment Budget': 0.00,
    'Transportation Budget': 0.00,
    'Utilities Budget': 0.00,
    'Shopping Budget': 0.00,
  };

  // List to store transactions
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      budgetName = prefs.getString('budgetName') ?? 'Grocery Budget';
      budgetDate = prefs.getString('budgetDate') ?? 'March 25, 2025';
      final amount = prefs.getString('budgetAmount') ?? '1000.00';
      budgetAmount = '\$$amount';
      budgetLeft = '\$${(double.tryParse(amount) ?? 1000.0) - 300.0}';
    });
  }

  void _updateBudgetAmounts(String selectedBudget) {
    setState(() {
      budgetAmount =
          '\$${budgets[selectedBudget]?.toStringAsFixed(2) ?? '0.00'}';
      budgetLeft =
          '\$${(budgets[selectedBudget] ?? 0.0) - (spentAmounts[selectedBudget] ?? 0.0)}';
    });
  }

  Future<void> _addNewPurchase() async {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              'Add New Purchase',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Budget: $budgetName',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFC300)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFC300)),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFC300)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFC300)),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.white70)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFC300),
                ),
                onPressed: () {
                  if (amountController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty) {
                    final amount =
                        double.tryParse(amountController.text) ?? 0.0;
                    final description = descriptionController.text;
                    final currentDate = DateTime.now();
                    final formattedDate =
                        '${currentDate.month}/${currentDate.day}/${currentDate.year}';

                    setState(() {
                      // Update spent amount
                      spentAmounts[budgetName] =
                          (spentAmounts[budgetName] ?? 0.0) + amount;

                      // Add to transactions
                      transactions.add({
                        'budget': budgetName,
                        'description': description,
                        'amount': amount,
                        'date': formattedDate,
                      });

                      // Update budget display
                      _updateBudgetAmounts(budgetName);
                    });

                    Navigator.pop(context);
                  }
                },
                child: Text('Add', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
    );
  }

  Future<void> _addNewBudget() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              'Add New Budget',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Budget Name',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFC300)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFC300)),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Budget Amount',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFC300)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFC300)),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.white70)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFC300),
                ),
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      amountController.text.isNotEmpty) {
                    final newBudgetName = nameController.text;
                    final newBudgetAmount =
                        double.tryParse(amountController.text) ?? 0.0;

                    setState(() {
                      budgets[newBudgetName] = newBudgetAmount;
                      spentAmounts[newBudgetName] = 0.0;
                      budgetName = newBudgetName;
                      _updateBudgetAmounts(newBudgetName);
                    });

                    Navigator.pop(context);
                  }
                },
                child: Text('Add', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildBudgetTab(context),
      _buildTransactionTab(),
      _buildSettingsTab(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Gegg'), backgroundColor: Colors.black),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFFFC300),
        unselectedItemColor: Colors.white,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          Text(
            'Home',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          // Budget Dropdown
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFFFC300)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: budgetName,
              isExpanded: true,
              dropdownColor: Colors.black,
              style: TextStyle(color: Colors.white, fontSize: 18),
              underline: SizedBox(),
              items:
                  budgets.keys.map((String budget) {
                    return DropdownMenuItem<String>(
                      value: budget,
                      child: Text(budget),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    budgetName = newValue;
                    _updateBudgetAmounts(newValue);
                  });
                }
              },
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  budgetAmount,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFC300),
                  ),
                ),
                Text(
                  budgetDate,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 16),
                Text(
                  budgetLeft,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFC300),
                  ),
                ),
                Text(
                  'Left in Budget',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transactions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton(
                onPressed: _addNewPurchase,
                child: Text('Add Purchase'),
              ),
            ],
          ),
          Text(budgetDate, style: TextStyle(color: Colors.white70)),
          SizedBox(height: 16),
          // Display transactions for current budget
          ...transactions
              .where((t) => t['budget'] == budgetName)
              .map(
                (transaction) => Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFAAA29F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.black),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction['description'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              transaction['date'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '-\$${transaction['amount'].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _addNewBudget,
            child: Text('Add New Budget'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTab() {
    return ListView(
      padding: EdgeInsets.all(24),
      children:
          transactions
              .map(
                (transaction) => ListTile(
                  leading: Icon(Icons.shopping_cart, color: Color(0xFFFFC300)),
                  title: Text(
                    "${transaction['description']} (${transaction['budget']})",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    transaction['date'],
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    "-\$${transaction['amount'].toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildSettingsTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Notifications Section
          Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Budget Limit Alert
                  ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: Color(0xFFFFC300),
                    ),
                    title: Text(
                      'Budget Limit Alerts',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Get notified when approaching budget limits',
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: Color(0xFFFFC300),
                    ),
                  ),
                  // Set Alert Threshold
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alert Threshold',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Percentage',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  suffixText: '%',
                                  suffixStyle: TextStyle(color: Colors.white70),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFFC300),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFFC300),
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFC300),
                              ),
                              child: Text(
                                'Set',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          // Logout Button
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('username');
              await prefs.remove('password');
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
