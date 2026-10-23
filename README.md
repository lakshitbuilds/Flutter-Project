# Campus Catalog

Simple Flutter project using the feature folders and widgets taught in lj_class_code.

## Structure

- main.dart: starts GetMaterialApp
- home_screen.dart: dashboard with Products, Users and Logout buttons
- api_services/api_services.dart: HTTP API calls
- login/: login screen and controller
- register/: registration screen and controller
- products/: screen, controller and product model
- users/: screen, controller and user model

Screens use Scaffold, AppBar, Column, TextField, ElevatedButton, TextButton,
ListView.builder and ListTile. GetX controllers use Obx and loading indicators
as in the faculty examples. No custom UI widgets.

## Run

flutter pub get
flutter run

Demo login: emilys / emilyspass.

The existing DummyJSON API provides login, registration, products and users.
Registration is simulated: new accounts are not saved and cannot log in.
Use the demo account after demonstrating registration.

## Checks

flutter analyze
flutter test
