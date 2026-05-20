import 'package:aps_lanka_task_manager/providers/auth_provider.dart';
import 'package:aps_lanka_task_manager/providers/task_provider.dart';
import 'package:aps_lanka_task_manager/providers/theme_provider.dart';
import 'package:aps_lanka_task_manager/screens/login_screen.dart';
import 'package:aps_lanka_task_manager/services/auth_service.dart';
import 'package:aps_lanka_task_manager/services/local_storage_service.dart';
import 'package:aps_lanka_task_manager/services/task_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('login screen shows required fields', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = LocalStorageService();
    await storageService.init();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(
              authService: AuthService(),
              storageService: storageService,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => TaskProvider(
              taskApiService: TaskApiService(),
              storageService: storageService,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => ThemeProvider(storageService: storageService),
          ),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
