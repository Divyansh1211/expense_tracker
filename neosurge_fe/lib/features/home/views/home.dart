import 'package:flutter/material.dart';
import 'package:neosurge_fe/features/analytics/views/analytics.dart';
import 'package:neosurge_fe/features/home/views/widgets/add_expense.dart';
import '../../accounts/views/account.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF01AA71),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AddExpense(),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF01AA71)),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {},
              ),
            ],
          ),
        ),
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF01AA71),
          title: const Text("Home"),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(
                text: "Accounts",
              ),
              Tab(
                text: "Analytics",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Account(),
            Analytics(),
          ],
        ),
      ),
    );
  }
}
