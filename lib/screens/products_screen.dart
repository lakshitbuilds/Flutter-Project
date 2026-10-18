import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/catalog_controller.dart';
import '../models/product_model.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
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
              hintText: 'Search products or categories',
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
            if (catalog.productsLoading.value && catalog.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (catalog.productsError.value.isNotEmpty &&
                catalog.products.isEmpty) {
              return _RetryPanel(
                message: catalog.productsError.value,
                onRetry: catalog.loadProducts,
              );
            }
            final items = catalog.products.where((p) =>
                p.title.toLowerCase().contains(query) ||
                p.category.toLowerCase().contains(query)).toList();
            if (items.isEmpty) {
              return const Center(child: Text('No matching products found'));
            }
            return RefreshIndicator(
              onRefresh: catalog.loadProducts,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 760
                      ? 4
                      : constraints.maxWidth >= 480 ? 3 : 2;
                  return GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 13,
                      mainAxisSpacing: 13,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) =>
                        ProductCard(product: items[index]),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.to(() => ProductDetailScreen(product: product)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF1F4FD),
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.inventory_2_outlined,
                    size: 45,
                    color: Color(0xFF9BA8C7),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '\$' + product.price.toStringAsFixed(2),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3446A5),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 15, color: Color(0xFFF59E0B)),
                          Text(product.rating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F3FB),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Image.network(
                    product.thumbnail,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.inventory_2_outlined, size: 90),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  product.category.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF6274BE),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(product.title,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Text(
                  '\$' + product.price.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 25,
                    color: Color(0xFF3446A5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  children: [
                    Chip(label: Text('Rating: ${product.rating.toStringAsFixed(1)} / 5')),
                    Chip(label: Text('Stock: ${product.stock}')),
                    Chip(label: Text(product.brand)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: const TextStyle(
                      color: Color(0xFF556179), height: 1.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RetryPanel extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;
  const _RetryPanel({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded,
              size: 50, color: Color(0xFF94A3B8)),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
