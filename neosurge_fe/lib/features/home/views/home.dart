import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neosurge_fe/features/analytics/views/analytics.dart';
import 'package:neosurge_fe/features/auth/views/signup.dart';
import 'package:neosurge_fe/features/home/controller/expense_controller.dart';
import 'package:neosurge_fe/features/home/views/widgets/add_expense.dart';
import 'package:neosurge_fe/features/home/views/widgets/drawer.dart';
import 'package:neosurge_fe/global/controller/shared_preferences.dart';
import 'package:neosurge_fe/provider.dart';
import '../../accounts/views/account.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    getSummary();
    super.initState();
  }

  Future<void> getSummary() async {
    await ref.read(expenseControllerProvider.notifier).getFilteredData();
    await ref.read(expenseSummaryControllerProvider.notifier).getSummary();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(currentUserProvider);
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
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF01AA71)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${userData?.name!}",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${userData?.email!}",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const DrawerWidget(icon: Icons.upload, title: "Get Premium"),
              const Divider(height: 8),
              const DrawerWidget(icon: Icons.roofing, title: "Bank Sync"),
              const DrawerWidget(
                  icon: Icons.download_outlined, title: "Imports"),
              const DrawerWidget(icon: Icons.home_outlined, title: "Home"),
              const Divider(height: 8),
              DrawerWidget(
                icon: Icons.logout,
                title: "Logout",
                onTap: () {
                  ref.read(sharedPrefsControllerPovider).clear();
                  ref.read(authTokenProvider.notifier).update((state) => null);
                  ref
                      .read(currentUserProvider.notifier)
                      .update((state) => null);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                      (route) => false);
                },
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
