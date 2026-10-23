import 'package:get/get.dart';
import '../api_services/api_services.dart';
import 'product_model.dart';

class ProductsController extends GetxController {
  final isLoading = false.obs;
  final dataList = <Product>[].obs;
  final error = ''.obs;
  Future<void> loadData() async {
    if (isLoading.value) return;
    isLoading.value = true;
    error.value = '';
    try {
      dataList.value = await ApiServices().getProducts();
    } catch (e) {
      error.value = 'Unable to load products. Check your connection and retry.';
    } finally {
      isLoading.value = false;
    }
  }
}
