# Ilia Contacts

A mobile app developed with Flutter, using MVVM pattern and Clean Architecture.

## 📋 Features

*   **User Management**:
    *   View a list of registered contacts.
    *   Create new contacts with Name, Email, and Phone.
    *   Delete existing contacts.
*   **Validation**:
    *   Mandatory fields (Name, Email).
    *   Email format validation.
    *   Unique email verification (Backend conflict handling).
*   **Internationalization (i18n)**:
    *   Full support for English (`en-US`) and Portuguese (`pt-BR`).
*   **Error Handling**:
    *   Granular error management (Network, Not Found, Conflict/Duplicate, System).
    *   User-friendly error messages.

## 🏗️ Architecture & Design Decisions

The application follows a loosely coupled, testable architecture designed for scalability.

### Pattern: MVVM + Clean Architecture
*   **Model**: POJOs and DTOs (`ContactModel`, `CreateContactDto`).
*   **View**: Flutter Widgets (`screens`, `widgets`) responsible only for UI rendering.
*   **ViewModel**: Manages state and business logic using `ValueNotifier` and the `Command` pattern.
*   **Repository**: Abstracts the data source (API), allowing the app to switch between different data providers easily.

### Key Technical Decisions
*   **Dependency Injection**: Uses `get_it` to service key components (Dio, Logger, Repositories), facilitating testing and modularity.
*   **Functional Error Handling**: Uses a `Result<T>` type to handle success and failure states explicitly, avoiding unchecked exceptions and "try-catch hell".
*   **Command Pattern**: ViewModels expose `Command` objects that safely manage the execution state (loading, error, success) of async actions, preventing double-submissions and simplifying UI state updates.
*   **Environment Configuration**: Supports environment variables (e.g., `API_URL`) allows switching between dev/staging/prod environments without code changes.

## 🛠️ Tech Stack

*   **Core**: Flutter & Dart (SDK ^3.10.7)
*   **Networking**: `dio` + `pretty_dio_logger`
*   **State Management**: Native `ValueNotifier` + Command Pattern
*   **DI**: `get_it`
*   **Routing**: `go_router`
*   **Localization**: `easy_localization`
*   **Linting**: `flutter_lints`

## 📂 Project Structure

```
lib/
├── core/                   # Shared kernels
│   ├── config/             # DI, Env Variables
│   ├── error/              # Custom Exceptions
│   ├── models/             # Domain Models & DTOs
│   ├── repositories/       # Data Access Interfaces & Impl
│   ├── routes/             # App Navigation
│   └── utils/              # Results, Commands
├── features/               # Feature-based folder structure
│   ├── contacts/
│   │   ├── contacts_list/  # Components for listing
│   │   ├── create_contact/ # Components for creation
│   │   └── widgets/        # Feature-specific widgets
│   └── splash/             # Startup logic
└── main.dart               # Entry point
```

## 🚀 Getting Started

### Prerequisites
*   Flutter SDK installed
*   Backend service running (Node.js backend in other directory)

### Installation

1.  **Clone the repository**:
    ```bash
    git clone <repository_url>
    cd ilia_contacts
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    You can specify the API URL using the `--dart-define` flag.
    ```bash
    flutter run --dart-define=API_URL=http://localhost:3000
    ```
    or you can create a .env file with the `API_URL=<your.ip.>`. 
    In that case, you would run with the command below
    ```bash
    flutter run --dart-define-from-file=.env
    ```

    *Note: Replace `localhost` with your machine's IP address if running on a physical device.*

4. **Running local on a Android Emulator**:
    If you are running the backend locally, you can set the IP from API_URL to `10.0.2.2`.



## 🧪 Testing

The project is structured for easy unit testing. The use of Dependency Injection and Repositories allows for easy mocking of data sources.

To run tests:
```bash
flutter test
```

## Throubleshooting 
1. **Emulator can't access local IP**
    In that case, you can run the code below to configure the emulator (ADB CLI required)
    ```bash
    adb reverse tcp:3000 tcp:3000
    ``` 