import 'package:flutter_test/flutter_test.dart';
import 'package:flutterproject/models/app_user.dart';
import 'package:flutterproject/models/product_model.dart';

void main() {
  test('Product model reads API fields', () {
    final product = Product.fromJson({
      'id': 1,
      'title': 'Phone',
      'description': 'Test product',
      'category': 'electronics',
      'price': 19.95,
      'rating': 4.6,
      'stock': 12,
      'thumbnail': 'https://example.com/item.png',
    });
    expect(product.title, 'Phone');
    expect(product.price, 19.95);
    expect(product.rating, 4.6);
    expect(product.brand, 'Generic');
  });

  test('User model reads nested company data', () {
    final user = AppUser.fromJson({
      'id': 1,
      'firstName': 'Emily',
      'lastName': 'Johnson',
      'email': 'emily@example.com',
      'age': 28,
      'company': {'name': 'Example Ltd'},
    });
    expect(user.fullName, 'Emily Johnson');
    expect(user.company, 'Example Ltd');
    expect(user.age, 28);
  });
}
