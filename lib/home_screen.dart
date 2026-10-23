import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login/login_screen.dart';
import 'products/products_screen.dart';
import 'users/users_screen.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  const HomeScreen({super.key, required this.name});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful. Welcome to Campus Catalog!'),
          backgroundColor: Color(0xFF164E48),
        ),
      );
    });
  }

  void changeTab(int index) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() => selectedIndex = index);
  }

  void logout() {
    Get.offAll(() => const LoginScreen());
    Get.snackbar(
      'Logout',
      'You have logged out successfully.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: selectedIndex == 0
        ? AppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                tooltip: 'Logout',
                onPressed: logout,
                icon: const Icon(Icons.logout),
              ),
            ],
          )
        : null,
    body: selectedIndex == 0
        ? dashboard()
        : selectedIndex == 1
        ? const ProductsScreen()
        : const UsersScreen(),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: changeTab,
      selectedItemColor: const Color(0xFF164E48),
      unselectedItemColor: Colors.blueGrey,
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          activeIcon: Icon(Icons.inventory_2),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'Users',
        ),
      ],
    ),
  );

  Widget dashboard() => Scaffold(
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: const Color(0xFF164E48),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.school_outlined,
                    color: Color(0xFFB9D8C6),
                    size: 36,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Hello, ${widget.name}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Welcome to Campus Catalog.',
                    style: TextStyle(fontSize: 16, color: Color(0xFFD4E7DE)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Explore your catalog',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173D36),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Choose a section to get started.',
              style: TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => changeTab(1),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFFE3EEE7),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: Color(0xFF164E48),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Products',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Browse products and prices',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.blueGrey),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => changeTab(2),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFFF4EBD8),
                        child: const Icon(
                          Icons.people_outline,
                          color: Color(0xFF164E48),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Users',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Explore people and contact details',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.blueGrey),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
