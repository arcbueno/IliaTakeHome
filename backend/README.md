# Backend - NestJS Users API

This is a backend application built with NestJS for managing user registrations. It allows creating users and listing them, enforcing business rules like unique emails.

## Problem Statement
Create an application composed of a backend and a mobile app that allows user registration and visualization.

## Business Rules Implemented
1.  **Register Users**: Allows registering users with Name and Email (mandatory).
2.  **Unique Emails**: Prevents registration of users with duplicate emails.
3.  **List Users**: Allows visualizing the list of registered users.

## Tech Decisions
-   **Framework**: [NestJS](https://nestjs.com/) was chosen for its structured, opinionated architecture that promotes scalability and maintainability.
-   **Language**: TypeScript for type safety and better developer experience.
-   **Database**: MongoDB with Mongoose. NoSQL was chosen for flexibility, and Mongoose provides a schema-based solution to model application data.
-   **Validation**: `class-validator` pipes are used for incoming request validation (DTOs), ensuring data integrity before it reaches the service layer.
-   **Documentation**: Code reflects API structure. `README` provides setup instructions.
-   **Formatting/Linting**: `eslint` and `prettier` are configured for consistent code style.

## Prerequisites
-   Node.js (v18 or higher)
-   Docker & Docker Compose (for the database)

## Setup & Running

1.  **Clone the repository** (if not already done).

2.  **Install Dependencies**:
    ```bash
    npm install
    ```

3.  **Environment Variables**:
    Create a `.env` file in the root directory. You can use `.env.example` as a template.
    ```
    MONGO_URI=mongodb://localhost:27017/ilia_users
    ```

4.  **Start Database**:
    Use Docker Compose to start the MongoDB instance.
    ```bash
    docker-compose up -d
    ```

5.  **Run the Application**:
    ```bash
    # development
    npm run start

    # watch mode
    npm run start:dev
    ```

## API Documentation

The API is documented using Swagger. Once the application is running, you can access the interactive documentation at:

**[http://localhost:3000/docs](http://localhost:3000/docs)**

This interface allows you to explore the endpoints, view request/response schemas, and test requests directly from the browser.

## Testing

Unit tests are included to ensure business logic correctness.

```bash
# unit tests
npm run test

# e2e tests
npm run test:e2e
```

## Project Structure
-   `src/users`: Contains the User module (Controller, Service, Schema, DTOs).
-   `src/users/dto`: Data Transfer Objects for validation.
-   `src/users/schemas`: Database schema definitions.
-   `test`: End-to-end tests.
