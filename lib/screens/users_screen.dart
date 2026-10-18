import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/catalog_controller.dart';
import '../models/app_user.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final CatalogController catalog = Get.find<CatalogController>();
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 15, 18, 6),
          child: TextField(
            onChanged: (value) => setState(() => query = value.toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Search users by name or email',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF0F3FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (catalog.usersLoading.value && catalog.users.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (catalog.usersError.value.isNotEmpty &&
                catalog.users.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded, size: 48),
                    const SizedBox(height: 12),
                    Text(catalog.usersError.value),
                    TextButton.icon(
                      onPressed: catalog.loadUsers,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }
            final users = catalog.users.where((u) =>
                u.fullName.toLowerCase().contains(query) ||
                u.email.toLowerCase().contains(query)).toList();
            if (users.isEmpty) {
              return const Center(child: Text('No matching users found'));
            }
            return RefreshIndicator(
              onRefresh: catalog.loadUsers,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                separatorBuilder: (_, _) => const SizedBox(height: 11),
                itemBuilder: (context, index) => UserCard(user: users[index]),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class UserCard extends StatelessWidget {
  final AppUser user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.fullName,
                      style: const TextStyle(
                          fontSize: 23, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text(user.email),
                    subtitle: const Text('Email'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone_outlined),
                    title: Text(user.phone),
                    subtitle: const Text('Phone'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.business_outlined),
                    title: Text(user.company),
                    subtitle: const Text('Company'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.cake_outlined),
                    title: Text('${user.age} years'),
                    subtitle: const Text('Age'),
                  ),
                ],
              ),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFE6ECFF),
                child: ClipOval(
                  child: Image.network(
                    user.image,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.person_outline, size: 30),
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(user.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF64748B))),
                    const SizedBox(height: 4),
                    Text(user.company,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
      ),
    );
  }
}
