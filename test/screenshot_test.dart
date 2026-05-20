import 'package:aps_lanka_task_manager/models/task_model.dart';
import 'package:aps_lanka_task_manager/providers/auth_provider.dart';
import 'package:aps_lanka_task_manager/providers/task_provider.dart';
import 'package:aps_lanka_task_manager/providers/theme_provider.dart';
import 'package:aps_lanka_task_manager/screens/add_task_screen.dart';
import 'package:aps_lanka_task_manager/screens/login_screen.dart';
import 'package:aps_lanka_task_manager/screens/register_screen.dart';
import 'package:aps_lanka_task_manager/services/auth_service.dart';
import 'package:aps_lanka_task_manager/services/local_storage_service.dart';
import 'package:aps_lanka_task_manager/services/task_api_service.dart';
import 'package:aps_lanka_task_manager/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalStorageService storageService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storageService = LocalStorageService();
    await storageService.init();
  });

  testWidgets('login screen screenshot', (tester) async {
    await _setPhoneSurface(tester);
    await tester.pumpWidget(_appWithProviders(const LoginScreen(), storageService));
    await expectLater(
      find.byType(LoginScreen),
      matchesGoldenFile('../screenshots/login_screen.png'),
    );
  });

  testWidgets('register screen screenshot', (tester) async {
    await _setPhoneSurface(tester);
    await tester.pumpWidget(
      _appWithProviders(const RegisterScreen(), storageService),
    );
    await expectLater(
      find.byType(RegisterScreen),
      matchesGoldenFile('../screenshots/register_screen.png'),
    );
  });

  testWidgets('add task screen screenshot', (tester) async {
    await _setPhoneSurface(tester);
    await tester.pumpWidget(
      _appWithProviders(const AddTaskScreen(), storageService),
    );
    await expectLater(
      find.byType(AddTaskScreen),
      matchesGoldenFile('../screenshots/add_task_screen.png'),
    );
  });

  testWidgets('task item screenshot', (tester) async {
    await _setPhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: TaskCard(
              task: const TaskModel(
                id: 1,
                title: 'Complete Flutter Test',
                completed: true,
                isLocal: true,
              ),
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        ),
      ),
    );
    await expectLater(
      find.byType(TaskCard),
      matchesGoldenFile('../screenshots/task_item.png'),
    );
  });
}

Widget _appWithProviders(Widget child, LocalStorageService storageService) {
  return MultiProvider(
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
    child: MaterialApp(home: child),
  );
}

Future<void> _setPhoneSurface(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
