# Campus Catalog — Mobile Computing Internal Examination

A Flutter + GetX application modeled after
[lj_class_code](https://github.com/SparksToIdeasdev10/lj_class_code),
especially the screen / controller / model / API service pattern.

**No Firebase, no API keys, and no private backend configuration needed.**
All networking uses the DummyJSON REST API.

## Requirements

| Internal examination requirement | Implementation |
| --- | --- |
| API login | POST https://dummyjson.com/auth/login |
| API registration | POST https://dummyjson.com/users/add (simulated registration) |
| Dashboard after login | Dashboard with live product/user counts, search and navigation |
| Products API | GET https://dummyjson.com/products?limit=100 |
| Users API | GET https://dummyjson.com/users?limit=100 |

## Important limitation of the registration API

DummyJSON is a **mock/testing API**, not a real account database.

- `POST /users/add` returns a response with a newly created user ID, but **does not actually save the account** on the server.
- Therefore, the username and password entered in the registration form **cannot be used to log in** later.
- Only existing DummyJSON sample users can log in via `POST /auth/login`.
- The app clearly explains this before registration and again after successful submission.
- **Never use a real personal password** in the registration demo.

If your examiner needs new accounts that can subsequently log in, a real persistent authentication API/backend is required. This project intentionally has no Firebase integration.

## Running the app

```bash
git pull origin main
flutter pub get
flutter run
```

No `--dart-define` or external service setup is required.

### Login credentials for evaluation

- **Username:** `emilys`
- **Password:** `emilyspass`

Tap **Sign in** to make the actual `POST /auth/login` request; the app verifies the API access token before navigating to the dashboard.

Or tap **Sign in with demo API account** to submit the same credentials to the real API automatically.

### Registration demonstration

1. From the login page choose **Create an account**.
2. Enter a test full name, username, email and a **throwaway test password**.
3. Press **Create account**.
4. The app calls `POST /users/add`, validates the response, shows the result and explains that this mock registration is not persisted.
5. Return to login and use the existing demo username/password above.

### Dashboard and required two APIs

1. After successful login, the dashboard requests products and users in parallel.
2. Show the live counts and green API connection indicators.
3. Open **Products**. Search and tap a card to see price, description, stock and rating.
4. Open **Users**. Search and tap a user to see their contact information.
5. Pull down to refresh, or use the refresh icon in the app bar.
6. Open the drawer or bottom navigation to switch screens; use **Sign out** to return to login.

The existing login session lives in memory and is cleared on sign-out/app restart.

## Structure

```text
lib/
  main.dart
  controllers/
    auth_controller.dart
    catalog_controller.dart
  models/
    app_user.dart
    product_model.dart
  screens/
    auth_screen.dart
    dashboard_screen.dart
    products_screen.dart
    users_screen.dart
  services/
    api_services.dart
```

- **API service:** HTTP GET and POST calls with JSON handling and timeouts.
- **Controllers (GetX):** loading status, errors, profile and fetched lists.
- **Models:** parse JSON responses into typed classes.
- **Screens:** login, registration, dashboard, products and users.

## Local checks

```bash
flutter analyze
flutter test
flutter run
```

This repository change was written and committed remotely; these commands
must be executed on a machine with the Flutter SDK to validate the application.
