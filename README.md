# Ilia Take-Home Challenge – Full Stack Application

This repository contains the solution for the Ilia Take-Home Challenge, featuring a complete system for user management with a **NestJS Backend** and a **Flutter Mobile Application**.

## 📌 Project Overview

The project is structured as a monorepo with two main directories:
- **`backend/`**: A RESTful API built with NestJS and MongoDB.
- **`frontend/`**: A mobile application built with Flutter (`ilia_contacts`), following Clean Architecture and MVVM principles.

### Key Features
- **User Registration**: Create users with Name and Email (mandatory fields).
- **Duplicate Prevention**: The system strictly prevents duplicate email registrations (Backend validation + Database constraints + Frontend error handling).
- **User Listing**: View all registered users in a clean list interface.
- **Robust Error Handling**: Http 409 Conflict handling, network error management, and user-friendly feedback.

---

## 🛠️ Technology Stack

### Backend
- **Framework**: [NestJS](https://nestjs.com/) (TypeScript)
- **Database**: MongoDB (via Docker & Mongoose)
- **Validation**: `class-validator` DTOs
- **Documentation**: Swagger UI
- **Testing**: Jest (Unit & E2E)

### Mobile (Frontend)
- **Framework**: Flutter (Dart)
- **Architecture**: MVVM + Clean Architecture
- **State Management**: Native `ValueNotifier` + Command Pattern (lightweight & testable)
- **Networking**: Dio
- **DI**: `get_it`
- **Routing**: `go_router`
- **Testing**: `mocktail` for Unit Tests

---

## 🚀 Getting Started

### Prerequisites
- **Node.js** (v18 or higher)
- **Docker & Docker Compose** (for MongoDB)
- **Flutter SDK** (v3.10+)
- **Android Studio** (for Emulator) or **Xcode** (for iOS Simulator)

### Step 1: Start the Backend 🟢

The backend requires a MongoDB instance. We use Docker Compose for this.

1.  Navigate to the backend directory:
    ```bash
    cd backend
    ```

2.  **Start Database Service**:
    ```bash
    docker-compose up -d
    ```
    *This starts a MongoDB container on port 27017.*

3.  **Install Dependencies**:
    ```bash
    npm install
    ```

4.  **Run the Server**:
    ```bash
    npm run start:dev
    ```
    The API will be available at `http://localhost:3000`.
    
    *Explore the API Docs at: [http://localhost:3000/docs](http://localhost:3000/docs)*

### Step 2: Run the Mobile App 📱

The mobile app needs to connect to the backend. The connection URL depends on your device (Emulator vs Simulator).

1.  Navigate to the flutter project:
    ```bash
    cd frontend/ilia_contacts
    ```

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the App**:

    **Option A: Android Emulator**
    Android emulators access the host machine via `10.0.2.2`.
    ```bash
    flutter run --dart-define=API_URL=http://10.0.2.2:3000
    ```

    **Option B: iOS Simulator / Web**
    iOS simulators access the host machine via `localhost`.
    ```bash
    flutter run --dart-define=API_URL=http://localhost:3000
    ```

    **Option C: Physical Device**
    Connect your phone and computer to the same Wi-Fi. Use your computer's local IP (e.g., `192.168.1.10`).
    ```bash
    flutter run --dart-define=API_URL=http://<YOUR_LOCAL_IP>:3000
    ```

---

## 🏗️ Architecture & Key Decisions

### Backend Principles
- **Layered Architecture**: Strictly separates `Controllers` (Entry Point), `Services` (Business Logic), and `Repositories/Schemas` (Data Access).
- **DTO Validation**: Uses Data Transfer Objects to validate incoming data *before* it reaches business logic, ensuring integrity.
- **Defensive Programming**: Checks for existing emails proactively before insertion to return precise `409 Conflict` errors instead of generic database faults.

### Frontend Principles
- **Clean Architecture**: Divided into `core` (shared infrastructure) and `features` (business domains), promoting separation of concerns.
- **Functional Error Handling**: Uses a `Result<T>` type instead of throwing exceptions. This forces the UI layer to explicitly handle both Success and Failure cases, preventing unhandled crashes.
- **Command Pattern**: Encapsulates async actions (loading state, execution, result) logic into `Command` objects, keeping ViewModels clean and removing boilerplate from the UI.
- **Dependency Injection**: Uses `get_it` service locator to decouple ViewModels from Repositories, making Unit Testing with mocks straightforward.

---

## 🧪 Running Tests

Ensure the quality of the codebase by running the test suites.

**Backend Tests:**
```bash
cd backend
npm run test      # Unit Tests
```

**Mobile Tests:**
```bash
cd frontend/ilia_contacts
flutter test
```

---

## 📝 License
This project is part of a technical assessment.
