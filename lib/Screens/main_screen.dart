import 'package:flutter/material.dart';
import 'package:icandoit/Screens/about_the_app.dart';

import 'blood_bank.dart';
import 'donation_orders.dart';
import 'my_profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    _tabController.index = index; // Using index directly for instant jump
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          toolbarHeight: 45,
          title: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const AboutTheApp(),
              );
            },
            child: Image.asset(
              'assets/fainallogo.png',
              height: 35,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            labelColor: Colors.red[900],
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.red[900],
            labelStyle: const TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            onTap: _onTabTapped,
            tabs: const [
              Tab(text: "بنك الدم"),
              Tab(text: "طلبات التبرع"),
              Tab(text: "حسابي"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          // Prevent swiping to ensure jumpTo feel
          children: [
            const BloodBank(),
            const DonationOrders(),
            const MyProfilePage(),
          ],
        ),
      ),
    );
  }
}
