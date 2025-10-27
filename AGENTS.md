# TradeTrackr Agent Guidelines

## Build/Lint/Test Commands
- **Build Android dev**: `flutter run --flavor dev --target lib/main_dev.dart`
- **Build Android prod**: `flutter run --flavor prod --target lib/main_prod.dart`
- **Build Linux**: `flutter run -d linux --target lib/main.dart`
- **Build Web dev**: `flutter run -t lib/main_dev.dart --web-renderer html --dart-define=flavor=dev -d chrome`
- **Lint**: `flutter analyze`
- **Test all**: `flutter test`
- **Test single**: `flutter test test/specific_test.dart`
- **Code gen**: `dart run build_runner build`

## Code Style Guidelines
- **Architecture**: Clean Architecture (presentation/domain/data layers)
- **State Management**: Riverpod with annotations (`@Riverpod(keepAlive: true)`)
- **Models**: Freezed immutable classes with `const factory` constructors
- **Error Handling**: Result pattern (`Result.success(value)` / `Result.failed(message)`)
- **Business Logic**: Use case pattern (`abstract interface class UseCase<R, P>`)
- **Data Access**: Repository pattern with interfaces in domain, implementations in data
- **Types**: Strict null safety, sealed classes for unions
- **Imports**: Relative imports within lib/, package imports for external deps
- **Naming**: camelCase for variables/methods, PascalCase for classes, snake_case for files
- **Formatting**: Follow flutter_lints rules, no trailing commas in function calls