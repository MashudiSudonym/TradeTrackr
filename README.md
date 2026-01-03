# TradeTrackr - Trading Journal App 📈

A comprehensive Flutter application for traders to record, analyze, and manage their trading activities offline with complete privacy and data control.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation & Setup](#installation--setup)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Development Workflow](#development-workflow)
- [Building & Running](#building--running)
- [Running with VSCode](#running-with-vscode)
- [Testing](#testing)
- [Contributing](#contributing)
- [Troubleshooting](#troubleshooting)
- [Project Status](#project-status)

## 🎯 Overview

TradeTrackr is a mobile and desktop application built with Flutter that serves as a comprehensive trading journal for traders. The app allows users to:

- Record and track all trading activities with detailed trade entries
- Analyze performance with profit/loss calculations and statistics
- Export/import data in CSV format for backup and migration
- Maintain complete privacy with offline storage using local SQLite database
- Access data across multiple platforms (Android, Linux, Web)

> 📖 **For detailed feature specifications, see [MVP Documentation](./docs/mvp-tradetrackr.md)**  
> 📊 **For data schema details, see [Data Schema](./docs/data-schema.md)**

## ✨ Features

### 👤 User Onboarding & Setup

- First-time user setup with personal information
- Date/time format preferences
- Automatic timezone detection
- Welcome screens with feature introduction

### 📊 Trade Management

- Record buy/sell trades with comprehensive details:
  - Entry/exit dates and times
  - Instrument/asset names
  - Position sizes and prices
  - Stop loss and take profit levels
  - Entry reasons and additional notes
- Automatic profit/loss calculations
- Trade validation and data integrity

### 📋 Journal & History

- Interactive trade history table
- Advanced filtering by date, instrument, and results
- Search functionality
- Sorting capabilities (ascending/descending)

### 📄 Trade Details

- Comprehensive trade information display
- Performance metrics (P/L, risk/reward ratio, holding duration)
- Edit and delete trade functionality
- Psychological notes and market conditions

### 💾 Data Management

- Complete offline functionality
- CSV export/import for backup and migration
- Local SQLite database with Drift ORM
- Automatic and manual backup options
- Data integrity and security

### ⚙️ Settings & Preferences

- User profile management
- Backup settings (automatic/manual scheduling)
- Display preferences (date/time formats, themes)
- Notification settings

### 🎨 User Experience

- Clean and intuitive interface using Shadcn UI
- Cross-platform compatibility (Android, Linux, Web)
- Responsive design for all screen sizes
- Dark/light theme support

## 🛠️ Tech Stack

### Frontend

- **Flutter** 3.35.5 - Cross-platform framework
- **Dart** 3.35.5 - Programming language
- **Riverpod** 3.0.0 - State management
- **Go Router** 16.2.1 - Navigation and routing
- **Shadcn UI** 0.31.8 - Modern UI component library

### Backend & Storage

- **SQLite** - Local database
- **Drift** 2.29.0 - Type-safe SQL query builder and ORM
- **Drift Flutter** 0.2.7 - Flutter integration for Drift
- **CSV** - Data export/import functionality
- **Path Provider** 2.1.3 - File system access
- **Permission Handler** 11.3.1 - Platform permissions

### Utilities & Tools

- **Freezed** 3.2.3 - Code generation for immutable models
- **JSON Serializable** 6.11.1 - JSON serialization
- **UUID** 4.1.0 - Unique identifier generation
- **Intl** 0.20.2 - Internationalization and date formatting
- **Flutter Dotenv** 6.0.0 - Environment variable management
- **Logger** 2.6.1 - Logging utility

### Development Tools

- **Riverpod Generator** 3.0.0 - State management code generation
- **Build Runner** 2.7.1 - Code generation runner
- **Custom Lint** 0.8.0 - Custom linting rules
- **Riverpod Lint** 3.0.0 - Riverpod-specific linting
- **Drift Dev** 2.29.0 - Drift development tools

### Testing

- **flutter_test** - Unit and widget testing
- **Mockito** 5.1.0 - Mocking framework

## 📋 Prerequisites

### System Requirements

- **Operating System**: Android, Linux, Windows, macOS, or Web
- **RAM**: Minimum 4GB (8GB recommended)
- **Storage**: 500MB free space
- **Display**: 1280x720 or higher resolution

### Software Requirements

- **Flutter SDK**: Version 3.35.5 (exactly this version)
- **Dart SDK**: Compatible with Flutter 3.35.5
- **VS Code** (recommended) or **Android Studio** with Flutter extensions
- **Git**: Version control system

### Recommended VSCode Extensions

When using VSCode, install these recommended extensions for optimal development experience:

- **Dart-Code.dart-code**: Official Dart extension
- **Dart-Code.flutter**: Official Flutter extension
- **ms-vscode.vscode-json**: JSON language support
- **redhat.vscode-yaml**: YAML language support
- **streetsidesoftware.code-spell-checker**: Spell checking
- **eamodio.gitlens**: Enhanced Git capabilities

> 💡 **Tip**: VSCode will automatically recommend these extensions when you open the project

### Version Management Tools

Choose one of the following to manage Flutter versions:

- **[mise](https://mise.jdx.dev/)** (recommended) - Modern version manager
- **[fvm](https://fvm.app/)** - Flutter Version Management

## 🚀 Installation & Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd trade_trackr
```

### 2. Install Flutter Version Manager

Choose one option:

**Option A: Using mise (Recommended)**

```bash
# Install mise if not already installed
curl https://mise.jdx.dev/install.sh | sh

# Install Flutter 3.35.5
mise install flutter@3.35.5
mise use flutter@3.35.5
```

**Option B: Using fvm**

```bash
# Install fvm globally
flutter pub global activate fvm

# Install Flutter 3.35.5
fvm install 3.35.5
fvm use 3.35.5
```

### 3. Verify Flutter Installation

```bash
flutter --version
# Should show: Flutter 3.35.5 • channel stable
```

### 4. Install Dependencies

```bash
flutter pub get
```

### 6. Code Generation

Generate the necessary code for Riverpod, Freezed, and Drift using the following command:

```bash
dart run build_runner build
```

## 📁 Project Structure

``` bash
trade_trackr/
├── android/                    # Android platform-specific code
├── linux/                      # Linux platform-specific code
├── web/                        # Web platform-specific code
├── docs/                       # Documentation
│   ├── data-schema.md         # Data schema specification
│   └── mvp-tradetrackr.md     # MVP feature specification
├── lib/                       # Main application code
│   ├── core/                  # Core utilities and constants
│   │   ├── constants/         # App constants
│   │   └── utils/             # Utility classes
│   ├── data/                  # Data layer
│   │   └── repository/        # Repository implementations
│   ├── domain/               # Domain layer (Business Logic)
│   │   ├── entity/           # Data models (Freezed)
│   │   ├── repository/       # Repository interfaces
│   │   └── use_case/         # Business use cases
│   ├── presentation/         # Presentation layer (UI)
│   │   ├── page/            # Screen widgets
│   │   └── provider/        # State management (Riverpod)
│   ├── app.dart             # Main app widget
│   ├── bootstrap.dart      # App initialization
│   ├── main.dart            # Application entry point
├── test/                     # Test files
├── pubspec.yaml            # Flutter dependencies
├── analysis_options.yaml   # Code analysis configuration
├── mise.toml               # Version management configuration
└── README.md              # This file
```

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

### Layers

1. **Presentation Layer** (`lib/presentation/`)
   - UI components and screens
   - State management with Riverpod
   - User interaction handling

2. **Domain Layer** (`lib/domain/`)
   - Business logic and rules
   - Use cases for application features
   - Entity definitions (immutable data models)

3. **Data Layer** (`lib/data/`)
   - Repository implementations
   - Local database operations
   - Data source abstractions

### Key Patterns

- **Dependency Injection**: Riverpod for dependency management
- **Result Pattern**: `Success<T>`/`Failed<T>` for error handling
- **Repository Pattern**: Abstraction over data sources
- **Use Case Pattern**: Business logic encapsulation

## 🔄 Development Workflow

### 1. Feature Development

```bash
# Create a new feature branch
git checkout -b feature/your-feature-name

# Make changes following the architecture
# 1. Create/Update entities in domain/entity/
# 2. Create use cases in domain/use_case/
# 3. Implement repositories in data/repository/
# 4. Create providers in presentation/provider/
# 5. Build UI in presentation/page/

# Generate code after changes
dart run build_runner build

# Run tests
flutter test

# Commit changes
git add .
git commit -m "feat: add your feature description"
```

### 2. Code Generation

```bash
# Watch mode for continuous code generation during development
dart run build_runner watch

# Clean and rebuild all generated code
dart run build_runner clean
dart run build_runner build -d
```

## 🏃‍♂️ Building & Running

### 📱 Android

```bash
# Run application
flutter run

# Build APK
flutter build apk
```

### 💻 Linux

```bash
# Run application
flutter run -d linux

# Build application
flutter build linux
# The built application will be in build/linux/x64/release/bundle/
```

### 🌐 Web

```bash
# Run application
flutter run -d chrome

# Build application
flutter build web
# The built web app will be in build/web/
```

### Build Output Locations

```bash
# Android APK
build/app/outputs/flutter-apk/app-release.apk

# Linux application
build/linux/x64/release/bundle/trade_trackr

# Web application
build/web/
```

### Running on Specific Platforms

```bash
# Run on Android device/emulator
flutter run -d <android_device_id>

# Run on Linux
flutter run -d linux

# Run on Web (Chrome)
flutter run -d chrome
```

## 💻 Running with VSCode

This project includes optimized VSCode configurations for easy development and debugging across all supported platforms.

### Prerequisites

1. **Install VSCode** with Flutter and Dart extensions
2. **Install recommended extensions** (see extensions recommendations above)
3. **Configure Flutter SDK path** in VSCode settings for your version manager (mise/fvm)

### Launch Configurations

The project includes a `.vscode/launch.json` file with optimized launch configurations for debugging across all supported platforms:

#### Platform Configurations

- **"TradeTrackr"**: Standard debug mode for the application
- **"TradeTrackr Linux"**: Debug mode for Linux platform
- **"TradeTrackr Web"**: Debug mode for web platform

### Build Tasks

The project includes automated build tasks for different platforms:

- **Flutter: Build APK**: Build APK for Android
- **Flutter: Build AppBundle**: Build AAB bundle for Google Play Store
- **Flutter: Build Linux App**: Build application for Linux
- **Flutter: Build Web**: Build web app

#### How to Use Build Tasks

1. Open VSCode Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`)
2. Type "Tasks: Run Task"
3. Select your desired build task from the list

### How to Run

#### Method 1: Using Run Panel (Recommended)

1. Open the project in VSCode
2. Click the **Run** icon in the sidebar (play button with bug)
3. Select **"TradeTrackr"** from the dropdown
4. Click the green **Play** button or press `F5`

#### Method 2: Using Command Palette

1. Open Command Palette: `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (macOS)
2. Type: "Debug: Select and Start Debugging"
3. Select your desired configuration
4. Press Enter

#### Method 3: Using Terminal

1. Open integrated terminal in VSCode: `Ctrl+Shift+`
2. Run: `flutter run`

### Platform-Specific Running

#### Running on Android

```bash
flutter run -d <device_id>
```

#### Running on Linux

```bash
flutter run -d linux
```

#### Running on Web

```bash
flutter run -d chrome
```

### Keyboard Shortcuts

- `F5`: Start debugging with selected configuration
- `Ctrl+Shift+P` / `Cmd+Shift+P`: Open Command Palette
- `Ctrl+Shift+B` / `Cmd+Shift+B`: Run build task
- `Ctrl+S` / `Cmd+S`: Save and auto-format

### Hot Reload & Hot Restart

When running the app:

- Press `r` in terminal for **Hot Reload**
- Press `R` (Shift+r) for **Hot Restart**
- Press `Shift+F5` to **Stop debugging**

### Running on Specific Device

```bash
# List available devices
flutter devices

# Run on specific Android device
flutter run -d <android_device_id>

# Run on Linux
flutter run -d linux

# Run on Web browser
flutter run -d chrome
```

### VSCode Tasks

The project includes several useful tasks accessible via Command Palette:

- **Flutter: Clean**: Clean build artifacts
- **Flutter: Get Dependencies**: Install/update dependencies
- **Flutter: Generate Code**: Run build_runner to generate code
- **Flutter: Watch Code Generation**: Continuous code generation during development
- **Flutter: Analyze**: Run static analysis
- **Flutter: Run Tests**: Execute unit tests
- **Flutter: Run Tests with Coverage**: Run tests with coverage report
- **Flutter: Build APK**: Build APK for production
- **Flutter: Build AppBundle**: Build AAB for Play Store
- **Flutter: Build Linux App**: Build for Linux platform
- **Flutter: Build Web**: Build web app for production

#### How to Use Tasks

1. Open Command Palette: `Ctrl+Shift+P`
2. Type: "Tasks: Run Task"
3. Select desired task from the list

### Troubleshooting VSCode

#### Flutter SDK Not Found

1. Check VSCode settings for correct Flutter SDK path
2. Ensure mise/fvm is properly configured
3. Restart VSCode

#### Launch Configuration Not Working

1. Ensure device/emulator/browser is connected
2. Ensure all dependencies are installed: `flutter pub get`

#### Platform-Specific Issues

**Android:**

- Ensure Android SDK is installed and configured
- Check device is connected and authorized

**Linux:**

- Ensure Linux development dependencies are installed
- Check for any missing system libraries

**Web:**

- Ensure Chrome/Firefox is installed
- Check for any web-specific dependency issues

#### Extensions Not Working

1. Open Extensions panel: `Ctrl+Shift+X`
2. Install missing extensions manually
3. Reload VSCode window: `Ctrl+Shift+P` → "Developer: Reload Window"

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage report
flutter test --coverage

# Run specific test file
flutter test test/some_test.dart

# Run tests with verbose output
flutter test -v
```

### Test Structure

``` bash
test/
├── domain/
│   ├── entity/          # Entity unit tests
│   └── use_case/        # Use case unit tests
├── data/
│   └── repository/      # Repository implementation tests
├── presentation/
│   ├── provider/        # Provider tests
│   └── page/            # Page integration tests
```

## 🤝 Contributing

### Code Style Guidelines

- Follow the existing code style and conventions
- Use meaningful variable and function names
- Add comments for complex business logic
- Ensure all code is null-safe
- Follow the established architectural patterns

### Pull Request Process

1. Create a feature branch from `main`
2. Make your changes following the architecture
3. Write or update tests for your changes
4. Ensure all tests pass
5. Update documentation if needed
6. Create a pull request with a clear description

### Commit Message Convention

``` bash
feat: add new trade recording feature
fix: resolve profit calculation bug
docs: update README installation guide
style: format code according to style guide
refactor: restructure trade repository
test: add unit tests for trade validation
```

## 🔧 Troubleshooting

### Common Issues

**1. Flutter Version Issues**

```bash
# Ensure correct Flutter version
flutter --version

# If using mise
mise use flutter@3.35.5

# If using fvm
fvm use 3.35.5
```

**2. Code Generation Issues**

```bash
# Clean and rebuild generated code
dart run build_runner clean
dart run build_runner build -d

# Check for build errors
flutter analyze
```

**3. Dependency Issues**

```bash
# Clean dependencies
flutter clean
flutter pub get

# Update dependencies
flutter pub upgrade
```

**4. Android Build Issues**

```bash
# Clean Android build
cd android
./gradlew clean
cd ..

# Accept Android licenses
flutter doctor --android-licenses
```

**5. VSCode Issues**

```bash
# Reload VSCode window
Ctrl+Shift+P → "Developer: Reload Window"

# Check Flutter SDK path in VSCode settings
# File → Preferences → Settings → Search "flutter"

# Verify VSCode extensions are installed
# View → Extensions → Search for "flutter" and "dart"
```

### Getting Help

- Check the [Issues](../../issues) page for known problems
- Review the [MVP Specification](./docs/mvp-tradetrackr.md) for feature details
- See the [Data Schema](./docs/data-schema.md) for data structure information

## 📊 Project Status

🚧 Currently in MVP development phase

### MVP Features Status

- 🔄 **User Onboarding & Setup Awal**: First-time user setup and personalization
- 🔄 **Input Trade Baru**: Form for recording new trading transactions
- 🔄 **Daftar Jurnal Trading**: Interactive trade history table with filtering
- 🔄 **Detail Trade**: Comprehensive trade information display
- 🔄 **Export Data Manual ke CSV**: Manual data export to CSV format
- 🔄 **Backup Otomatis Terjadwal**: Scheduled automatic backup system
- 🔄 **Import Data CSV**: Data import from CSV files
- 🔄 **Pengaturan Dasar**: User preferences and application settings
- 🔄 **UI Responsif & Minimalis**: Clean and responsive user interface

### Technical Status

- ✅ **Architecture**: Clean Architecture setup (planned)
- 🔄 **Database**: SQLite with Drift ORM implementation (planned)
- 🔄 **State Management**: Riverpod implementation (planned)
- 🔄 **Cross-Platform**: Android, Linux, and Web support (planned)
- 🔄 **Offline Storage**: Local data persistence (planned)
- 🔄 **Testing**: Unit tests for core functionality (planned)
- 🔄 **Code Generation**: Freezed and Riverpod generators setup (planned)

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Developer

Developed by Tiga Satu Desember  
Organization: io.tigasatudesember

---

**TradeTrackr** - Track smarter, trade better. 📈
