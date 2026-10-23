import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'users_controller.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final UsersController controller = Get.put(UsersController());
  @override
  void initState() {
    super.initState();
    controller.loadData();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Users'),
      actions: [
        IconButton(
          onPressed: controller.loadData,
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.error.value.isNotEmpty) {
        return Center(child: Text(controller.error.value));
      }
      if (controller.dataList.isEmpty) {
        return const Center(child: Text('No Data Found'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.dataList.length,
        itemBuilder: (context, index) {
          final data = controller.dataList[index];
          return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFDDECE6),
                  child: Text(
                    data.firstName.isEmpty
                        ? '?'
                        : data.firstName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF164E48),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  data.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${data.email}\n${data.phone}',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                    ),
                  ),
                ),
                isThreeLine: true,
              ),
            ),
          );
        },
      );
    }),
  );
}
