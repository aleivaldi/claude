# Flutter Project Structure

## Directory Tree

```
project-app/
├── lib/
│   ├── main.dart                    # Entry point
│   │
│   ├── app/
│   │   ├── app.dart                 # MaterialApp/CupertinoApp
│   │   ├── router.dart              # GoRouter configuration
│   │   └── theme.dart               # App theme
│   │
│   ├── features/                    # Feature-based modules
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   │   └── auth_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── user_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── login_usecase.dart
│   │   │   │       └── logout_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── auth_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── login_screen.dart
│   │   │       │   └── register_screen.dart
│   │   │       └── widgets/
│   │   │           └── login_form.dart
│   │   │
│   │   ├── dashboard/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       ├── screens/
│   │   │       │   └── dashboard_screen.dart
│   │   │       └── widgets/
│   │   │
│   │   └── profile/
│   │       └── ...
│   │
│   ├── shared/
│   │   ├── widgets/                 # Shared widgets
│   │   │   ├── app_button.dart
│   │   │   ├── app_text_field.dart
│   │   │   ├── loading_indicator.dart
│   │   │   └── error_widget.dart
│   │   ├── extensions/              # Dart extensions
│   │   │   ├── context_extensions.dart
│   │   │   └── string_extensions.dart
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   └── formatters.dart
│   │   └── constants/
│   │       ├── app_colors.dart
│   │       ├── app_sizes.dart
│   │       └── app_strings.dart
│   │
│   ├── core/
│   │   ├── network/
│   │   │   ├── dio_client.dart      # HTTP client
│   │   │   ├── api_interceptor.dart
│   │   │   └── api_endpoints.dart
│   │   ├── storage/
│   │   │   ├── secure_storage.dart
│   │   │   └── preferences.dart
│   │   ├── error/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   └── usecases/
│   │       └── usecase.dart         # Base usecase
│   │
│   └── l10n/                        # Localization
│       ├── app_en.arb
│       └── app_it.arb
│
├── test/
│   ├── unit/
│   │   ├── features/
│   │   │   └── auth/
│   │   │       └── auth_provider_test.dart
│   │   └── core/
│   ├── widget/
│   │   └── features/
│   │       └── auth/
│   │           └── login_screen_test.dart
│   └── helpers/
│       └── test_helpers.dart
│
├── integration_test/
│   └── app_test.dart
│
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── .env.example
├── .env.development
├── .env.production
├── analysis_options.yaml
├── pubspec.yaml
└── README.md
```

## Key Files Content

### lib/main.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_app/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await initializeApp();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

Future<void> initializeApp() async {
  // Initialize secure storage, analytics, etc.
}
```

### lib/app/app.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_app/app/router.dart';
import 'package:project_app/app/theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'App Name',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### lib/app/router.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:project_app/features/auth/presentation/screens/login_screen.dart';
import 'package:project_app/features/dashboard/presentation/screens/dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isAuthenticated && !isAuthRoute) {
        return '/auth/login';
      }

      if (isAuthenticated && isAuthRoute) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/dashboard',
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
});
```

### lib/features/auth/presentation/providers/auth_provider.dart
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_app/features/auth/domain/entities/user.dart';
import 'package:project_app/features/auth/domain/usecases/login_usecase.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
  );
});

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthNotifier({
    required LoginUseCase loginUseCase,
  })  : _loginUseCase = loginUseCase,
        super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (user) => state = state.copyWith(
        isLoading: false,
        user: user,
      ),
    );
  }

  void logout() {
    state = const AuthState();
  }
}
```

### lib/core/network/dio_client.dart
```dart
import 'package:dio/dio.dart';
import 'package:project_app/core/storage/secure_storage.dart';

class DioClient {
  late final Dio _dio;
  final SecureStorage _storage;

  DioClient(this._storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment('API_URL'),
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Handle token expiration
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
  }) {
    return _dio.post<T>(path, data: data);
  }
}
```

## pubspec.yaml

```yaml
name: project_app
description: A Flutter application
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.4.9

  # Navigation
  go_router: ^13.0.1

  # Network
  dio: ^5.4.0

  # Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.2

  # Utils
  fpdart: ^1.1.0
  equatable: ^2.0.5
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  mocktail: ^1.0.1
  integration_test:
    sdk: flutter

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/icons/
```

## Commands

```bash
# Development
flutter run                                    # Run app
flutter run --dart-define=API_URL=http://...   # With env variable

# Build
flutter build apk                              # Android APK
flutter build appbundle                        # Android Bundle
flutter build ios                              # iOS
flutter build web                              # Web

# Quality
dart format .                                  # Format code
flutter analyze                                # Static analysis
dart fix --apply                               # Apply fixes

# Testing
flutter test                                   # Unit + Widget tests
flutter test --coverage                        # With coverage
flutter test test/unit                         # Unit only
flutter test test/widget                       # Widget only
flutter drive --target=integration_test/app_test.dart  # Integration

# Code generation (if using)
dart run build_runner build --delete-conflicting-outputs
```
