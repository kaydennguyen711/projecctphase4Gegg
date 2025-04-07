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
  String budgetLeft = '\$700.00';

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
                  budgetName,
                  style: TextStyle(fontSize: 18, color: Colors.white),
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
          Text('Transactions', style: Theme.of(context).textTheme.titleLarge),
          Text(budgetDate, style: TextStyle(color: Colors.white70)),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFAAA29F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.black),
                SizedBox(width: 12),
                Text(
                  '- \$300.00 - Sobeys',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed:
                () => Navigator.pushNamed(
                  context,
                  '/edit-budget',
                ).then((_) => _loadBudget()),
            child: Text('Edit Budget'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTab() {
    return ListView(
      padding: EdgeInsets.all(24),
      children: const [
        ListTile(
          leading: Icon(Icons.shopping_cart, color: Color(0xFFFFC300)),
          title: Text("Sobeys", style: TextStyle(color: Colors.white)),
          subtitle: Text(
            "March 25, 2025",
            style: TextStyle(color: Colors.white70),
          ),
          trailing: Text(
            "-\$300.00",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('username');
          await prefs.remove('password');
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: const Text('Logout'),
      ),
    );
  }
}
