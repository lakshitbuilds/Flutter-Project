import 'package:get/get.dart';
import '../api_services/api_services.dart';
import 'user_model.dart';

class UsersController extends GetxController {
  final isLoading = false.obs;
  final dataList = <AppUser>[].obs;
  final error = ''.obs;
  Future<void> loadData() async {
    if (isLoading.value) return;
    isLoading.value = true;
    error.value = '';
    try {
      dataList.value = await ApiServices().getUsers();
    } catch (e) {
      error.value = 'Unable to load users. Check your connection and retry.';
    } finally {
      isLoading.value = false;
    }
  }
}
