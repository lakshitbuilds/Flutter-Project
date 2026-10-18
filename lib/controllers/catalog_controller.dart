import 'package:get/get.dart';

import '../models/app_user.dart';
import '../models/product_model.dart';
import '../services/api_services.dart';

class CatalogController extends GetxController {
  final ApiServices _api = ApiServices();

  final products = <Product>[].obs;
  final users = <AppUser>[].obs;
  final productsLoading = false.obs;
  final usersLoading = false.obs;
  final productsError = ''.obs;
  final usersError = ''.obs;

  Future<void> loadAll() async {
    await Future.wait([loadProducts(), loadUsers()]);
  }

  Future<void> loadProducts() async {
    productsLoading.value = true;
    productsError.value = '';
    try {
      products.assignAll(await _api.getProducts());
    } catch (_) {
      productsError.value = 'Unable to load products. Check your connection.';
    } finally {
      productsLoading.value = false;
    }
  }

  Future<void> loadUsers() async {
    usersLoading.value = true;
    usersError.value = '';
    try {
      users.assignAll(await _api.getUsers());
    } catch (_) {
      usersError.value = 'Unable to load users. Check your connection.';
    } finally {
      usersLoading.value = false;
    }
  }
}
