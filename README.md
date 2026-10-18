# Campus Catalog — Flutter Mobile Computing Internal Examination

A Flutter application built around the concepts from
[SparksToIdeasdev10/lj_class_code](https://github.com/SparksToIdeasdev10/lj_class_code),
especially the class_e examples for GetX controllers, API services, models,
ListView, GridView, navigation and forms.

## Examination checklist

| Requirement | Where implemented |
| --- | --- |
| Login using API or Firebase | Firebase Email/Password REST API, or DummyJSON demo API login |
| Registration | Firebase Email/Password REST API |
| Dashboard | Live status cards and navigation after successful login |
| Products API | GET https://dummyjson.com/products |
| Users API | GET https://dummyjson.com/users |

The products and users endpoints are requested as soon as the dashboard opens.
The app shows loading, error, retry, search, detail views, and pull-to-refresh.

## Start immediately (demo mode)

1. Clone the repository and open it in Android Studio / VS Code.
2. Run:

   ```bash
   flutter pub get
   flutter run
   ```

3. On the login screen press **Try demo login (no setup)**.
   This calls DummyJSON's test login endpoint using its public demo credentials
   and opens the real dashboard with live Products and Users API responses.

Demo login is for showcasing the app, not for creating a private account.

## Enable real registration and login (Firebase)

The **Register** and **Sign in** form uses Google's Firebase Authentication
REST API. This is real account creation/authentication, not a mock registration.
You must connect your own Firebase project; no key is supplied in this repository.

1. Open [Firebase Console](https://console.firebase.google.com/), create
   or select a Firebase project.
2. Go to **Build > Authentication > Sign-in method** and enable
   **Email/Password**.
3. Under **Project settings > General**, find your project's **Web API Key**.
4. Launch using the key supplied at build time:

   ```bash
   flutter run --dart-define=FIREBASE_API_KEY=YOUR_FIREBASE_WEB_API_KEY
   ```

   To build Android:

   ```bash
   flutter build apk --dart-define=FIREBASE_API_KEY=YOUR_FIREBASE_WEB_API_KEY
   ```

5. Choose **Create an account**, register with an email and password of 6+
   characters, then sign out and sign in using the same credentials.

The Firebase key is an identifier rather than a password. Firebase API keys
may still need appropriate API restrictions and monitoring. Never commit
private service-account keys. For this exam project, user sessions are
in-memory only and sign-in is required again after a cold start.

**For Flutter web:** configure your Firebase project's Authorized domains
as required by its Auth setup. If needed, allow the project origin.

## Project files

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

- **Models** read JSON into typed Dart objects.
- **ApiServices** calls both required GET APIs and the authentication APIs.
- **GetX Controllers** manage loading, success, failure, and screen state.
- **Screens** contain user interface widgets and navigation.

## Teacher demo flow

1. Sign in with Firebase, or press the demo login button.
2. Show the dashboard's two API status indicators and loaded record counts.
3. Open **Products**, search an item, and tap to see details.
4. Open **Users**, search a name, and tap to see contact information.
5. Pull down to refresh an API list.
6. Sign out, register a Firebase test account, then sign in with it.

## Testing

```bash
flutter analyze
flutter test
```

**Note:** DummyJSON is sample data. The product and user listings are not
the same as the accounts created with Firebase. Firebase credentials are
not sent to DummyJSON.
