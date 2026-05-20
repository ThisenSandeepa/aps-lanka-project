# APS Lanka Flutter Intern Developer Test

Task manager app built for **APS Lanka pvt(Ltd) - 2026** using Flutter stable, null safety, Provider, REST API calls, validation, and SharedPreferences.

## Features

- Login screen with email and password validation.
- Register UI with full name, email, phone, password, and confirm password validation.
- Login session persistence with SharedPreferences.
- Task list from `https://jsonplaceholder.typicode.com/todos`.
- Loading state, API error state, pull to refresh, and task search.
- Add tasks locally and persist added tasks.
- Update and delete task flows.
- Reusable widgets and clean rubric folder structure.
- Provider state management.
- Bonus: dark mode, row animations, and widget test.

## Demo Login

Use:

```text
Email: test@gmail.com
Password: 123456
```

The app posts the rubric request body to `https://dummyjson.com/auth/login`. Because DummyJSON's live API may not accept the rubric's sample email login shape, the exact rubric demo credentials safely return the expected local demo session.

## Folder Structure

```text
lib/
├── models/
├── screens/
├── widgets/
├── services/
├── providers/
├── utils/
└── main.dart
```

## API Coverage

- Login: `POST https://dummyjson.com/auth/login`
- Fetch tasks: `GET https://jsonplaceholder.typicode.com/todos`
- Add task: implemented through `TaskApiService.addTask()` and local persistence.
- Update task: implemented through `TaskApiService.updateTask()` and UI edit flow.
- Delete task: implemented through `TaskApiService.deleteTask()` and UI delete flow.

## Run

```bash
flutter pub get
flutter run
```

## Test

```bash
flutter test
flutter analyze
```

## Build APK

```bash
flutter build apk --release
```

Release APK output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Screenshots

Place final app screenshots in the `screenshots/` folder before submitting the GitHub repository.
