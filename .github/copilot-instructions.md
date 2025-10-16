Sure — here’s a **rewritten, detailed and developer-friendly `COPILOT.md`** (in Markdown) tailored for your Flutter + Supabase hackathon project **Smart Blood Availability and Donor Coordination App**.
This version improves structure, gives Copilot precise architectural context, explains folder structure, modular coding rules, and includes explicit examples for modular Flutter development.

---

````markdown
# 🧠 Copilot Instructions for `smart_blood_availability` Flutter App

## 📘 Project Overview
This repository contains the **Smart Blood Availability and Donor Coordination Platform**, built with **Flutter** and **Supabase**.  
Its goal is to connect hospitals, blood banks, and donors through **real-time blood inventory tracking, donor matching, and emergency requests**.

Primary entry point:  
`smart_blood_availability/lib/main.dart`

---

## 🚀 Quick Start for Agents
Use these commands when generating or running code:

```bash
# Navigate to project folder
cd smart_blood_availability

# Fetch dependencies
flutter pub get

# Run the app on an emulator or connected device
flutter run

# Run tests
flutter test

# Format code to project style
dart format .
````

---

## 🏗️ Architecture Overview

The project follows a **modular architecture** to maintain clean, scalable code.
Each core module lives inside `lib/modules/`.

### Folder Structure

```
lib/
├── main.dart                 # App entry
├── core/                     # Shared utilities, constants, and themes
│   ├── config/               # App-wide configs
│   ├── utils/                # Helper classes and functions
│   ├── theme/                # Colors, text styles, etc.
│   └── widgets/              # Common reusable widgets
├── modules/
│   ├── auth/                 # Login, signup, and user session
│   ├── inventory/            # Real-time blood stock dashboard
│   ├── emergency/            # Emergency blood request feature
│   ├── donors/               # Donor matching and profile management
│   ├── notifications/        # Push notifications and reminders
│   └── awareness/            # Awareness and impact section (articles, data)
└── services/
    ├── supabase_service.dart # Supabase connection and API helpers
    └── location_service.dart # Location-based donor matching
```

---

## 🧩 Modular Design Rules for Copilot

* **Each file should ideally be under 250–300 lines.**
* For each feature, create:

  * `model/` for data models
  * `view/` for UI
  * `controller/` or `viewmodel/` for logic
  * `service/` for API or Supabase interactions

**Example:**
For the Emergency Request feature:

```
lib/modules/emergency/
├── model/emergency_request.dart
├── view/emergency_screen.dart
├── controller/emergency_controller.dart
└── service/emergency_service.dart
```

---

## 🔌 Supabase Integration

Supabase handles:

* Authentication (email/password or OTP)
* Database (blood inventory, donors, hospitals)
* Realtime updates for blood stock
* Storage (optional: certificates, documents)

**Key file:**
`lib/services/supabase_service.dart`

**Connection setup example:**

```dart
final supabase = SupabaseClient('SUPABASE_URL', 'SUPABASE_ANON_KEY');
```

Copilot should:

* Use async/await for all Supabase interactions.
* Keep query logic inside `service` files.
* Reuse `supabase_service.dart` for database reads/writes.

---

## 🧱 Code Style & Conventions

* Follow **Flutter lints** defined in `analysis_options.yaml`.
* Format all code with:

  ```bash
  dart format .
  ```
* Use **CamelCase** for class names, **snake_case** for file names.
* Use `Theme.of(context)` for styling, not hard-coded colors.
* UI widgets should be stateless when possible.
* Split large widgets into smaller, reusable components under `lib/core/widgets/`.

---

## 🧪 Testing Guidelines

* Add widget tests for each major view in `test/` folder.
* Use mock Supabase client for testing database functions.
* Example:

  ```
  test/modules/inventory/inventory_test.dart
  ```

---

## 📱 Platform Folders

* Android: `android/`
* iOS: `ios/`
* Web: `web/`
* Desktop: `macos/`, `linux/`, `windows/`

**Do not** modify generated files such as:

* `*/ephemeral/`
* `GeneratedPluginRegistrant.*`

---

## ⚙️ Developer Workflow Examples

### Add a new module

1. Create folder under `lib/modules/feature_name/`
2. Add:

   * `model/`
   * `view/`
   * `controller/`
   * `service/`
3. Register routes in `lib/core/config/app_routes.dart`
4. Import the screen in `main.dart` or Navigator routes

### Add a new dependency

```bash
flutter pub add <package_name>
flutter pub get
```

Then import it where needed and commit `pubspec.yaml`.

---

## ❌ What NOT to do

* Don’t write all logic in a single widget file.
* Don’t modify platform build files unless adding a plugin.
* Don’t hardcode secrets or Supabase keys — use `.env` if possible.
* Don’t edit generated files or folders like `build/`, `.dart_tool/`, or `ephemeral/`.

---

## 🧠 PR & CI Notes

* Keep pull requests small and feature-focused.
* Include testing steps or screenshots for UI changes.
* Lint before committing:

  ```bash
  flutter analyze
  ```
* No CI/CD setup yet — don’t add workflows without approval.

---

## 📞 Need Clarification?

If build fails due to missing SDK paths:

* Ensure `android/local.properties` includes:

  ```
  flutter.sdk=/path/to/flutter
  ```
* Confirm environment variables for Android SDK and Xcode are set correctly.

---

*This document ensures Copilot and developers can collaborate efficiently, maintaining modularity, code quality, and hackathon-ready velocity.*

```

---

Would you like me to also generate a **folder and file structure scaffold** (with empty Dart files and boilerplate code for each module) that you can directly add to your Flutter project? That would help Copilot start writing context-aware code right away.
```
