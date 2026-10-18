import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/catalog_controller.dart';
import 'auth_screen.dart';
import 'products_screen.dart';
import 'users_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final CatalogController catalog = Get.find<CatalogController>();
  final AuthController auth = Get.find<AuthController>();
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => catalog.loadAll());
  }

  Future<void> _confirmLogout() async {
    final logout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You can sign in again at any time.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (logout == true) {
      auth.logout();
      Get.offAll(() => const AuthScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    const titles = ['Overview', 'Products', 'Users'];
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          titles[selectedTab],
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Refresh data',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              if (selectedTab == 1) {
                catalog.loadProducts();
              } else if (selectedTab == 2) {
                catalog.loadUsers();
              } else {
                catalog.loadAll();
              }
            },
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: _confirmLogout,
          ),
          const SizedBox(width: 7),
        ],
      ),
      body: IndexedStack(
        index: selectedTab,
        children: [
          _Overview(onSelect: (tab) => setState(() => selectedTab = tab)),
          const ProductsScreen(),
          const UsersScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab,
        onTap: (tab) => setState(() => selectedTab = tab),
        selectedItemColor: const Color(0xFF3446A5),
        unselectedItemColor: const Color(0xFF94A3B8),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_outlined),
            activeIcon: Icon(Icons.space_dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            activeIcon: Icon(Icons.people_alt),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final ValueChanged<int> onSelect;

  const _Overview({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final catalog = Get.find<CatalogController>();
    final auth = Get.find<AuthController>();

    return RefreshIndicator(
      onRefresh: catalog.loadAll,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF283C93), Color(0xFF6679D9)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    'Hello, ${auth.displayName.value} 👋',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Explore real-time data from two REST APIs.',
                  style: TextStyle(color: Color(0xFFE5EBFF)),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Color(0xFFB3F5DC)),
                    SizedBox(width: 8),
                    Text(
                      'Signed in successfully',
                      style: TextStyle(color: Color(0xFFB3F5DC)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Live API overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => _StatCard(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Products',
                    value:
                        catalog.productsLoading.value &&
                            catalog.products.isEmpty
                        ? '...'
                        : '${catalog.products.length}',
                    color: const Color(0xFF3B5CC4),
                    onTap: () => onSelect(1),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => _StatCard(
                    icon: Icons.groups_2_outlined,
                    label: 'Users',
                    value: catalog.usersLoading.value && catalog.users.isEmpty
                        ? '...'
                        : '${catalog.users.length}',
                    color: const Color(0xFF009D87),
                    onTap: () => onSelect(2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Explore data',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _ExploreTile(
            icon: Icons.inventory_2_outlined,
            title: 'Products catalog',
            subtitle: 'Prices, ratings, images & details',
            color: const Color(0xFFE9ECFF),
            onTap: () => onSelect(1),
          ),
          const SizedBox(height: 12),
          _ExploreTile(
            icon: Icons.people_alt_outlined,
            title: 'Users directory',
            subtitle: 'Profiles, contact & company details',
            color: const Color(0xFFDFF8F1),
            onTap: () => onSelect(2),
          ),
          const SizedBox(height: 24),
          const Text(
            'API connection status',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Obx(
            () => _ApiStatus(
              name: 'dummyjson.com/products',
              loading: catalog.productsLoading.value,
              error: catalog.productsError.value,
              count: catalog.products.length,
              onRetry: catalog.loadProducts,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => _ApiStatus(
              name: 'dummyjson.com/users',
              loading: catalog.usersLoading.value,
              error: catalog.usersError.value,
              count: catalog.users.length,
              onRetry: catalog.loadUsers,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Signed in using the DummyJSON authentication API',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.10),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 14),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ExploreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 27,
          backgroundColor: color,
          child: Icon(icon, color: const Color(0xFF3446A5)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 17),
      ),
    );
  }
}

class _ApiStatus extends StatelessWidget {
  final String name;
  final bool loading;
  final String error;
  final int count;
  final Future<void> Function() onRetry;
  const _ApiStatus({
    required this.name,
    required this.loading,
    required this.error,
    required this.count,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final success = !loading && error.isEmpty && count > 0;
    final message = loading
        ? 'Loading...'
        : error.isNotEmpty
        ? 'Failed • tap to retry'
        : success
        ? 'Connected • $count records'
        : 'No records returned';
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: ListTile(
        onTap: error.isNotEmpty ? onRetry : null,
        leading: Icon(
          loading
              ? Icons.sync
              : success
              ? Icons.check_circle_outline
              : Icons.error_outline,
          color: loading
              ? Colors.orange
              : success
              ? const Color(0xFF009D87)
              : Colors.redAccent,
        ),
        title: Text(name, style: const TextStyle(fontSize: 14)),
        subtitle: Text(message, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
