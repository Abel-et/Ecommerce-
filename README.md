# ShopSmart — Flutter E-Commerce Application

ShopSmart is a modern Flutter e-commerce application built as a practical,
end-to-end learning project. It explores how to design and implement a
complete shopping experience: authentication, product discovery, cart
management, checkout, order history, and profile customization.

The project is currently powered by a local SQLite database. The next major
milestone is a production backend built with Node.js and PostgreSQL.

## UI/UX Design Direction

The application follows the supplied **Flutter E-Commerce App UI/UX
Flowboard**, which defines the intended journey and screen structure:

1. Splash screen
2. Onboarding screens
3. Login and account creation
4. Product listing and category browsing
5. Product details
6. Shopping cart
7. Checkout and payment details
8. Order success confirmation
9. My Orders and order tracking
10. Profile and account settings
11. Admin product creation and editing

The flowboard also establishes the visual direction: clean mobile-first
layouts, reusable widgets, clear navigation, accessible forms, and a simple
shopping journey from product discovery to order completion.

## Current Features

### Authentication

- User registration and login
- Session-based current-user handling
- Form validation and user-facing error messages

### Product experience

- Product listing
- Search products
- Category filtering with reusable chips
- Product details
- Add products to cart
- Responsive light and dark theme support

### Cart and checkout

- Quantity management
- Order total calculation
- Shipping address display
- Payment method selection
- Checkout validation
- Order success confirmation

### Orders

- User-specific order history
- Search orders by ID
- Filter orders by status
- Pull-to-refresh support
- Order and order-item persistence

### Profile and settings

- Upload and persist a profile image
- Edit name and email
- Notification preference
- Font-size adjustment
- Light, dark, and system theme options
- Sign out

## Architecture

The project follows a feature-oriented structure with clear separation between
presentation, domain, and data layers:

```text
lib/
├── core/
│   ├── database/       # SQLite database and migrations
│   ├── di/             # Dependency injection
│   ├── navigation/     # Main application shell
│   ├── routes/         # GoRouter configuration
│   ├── session/        # Current-user session
│   └── settings/       # Global app preferences
├── features/
│   ├── auth/
│   ├── orders/
│   └── products/
└── main.dart
```

The application uses:

- **Flutter** and Dart
- **flutter_bloc** for predictable state management
- **GoRouter** for navigation
- **GetIt** for dependency injection
- **sqflite** for local persistence
- **fpdart** for typed success/failure results
- **image_picker** for profile image selection

## Getting Started

### Requirements

- Flutter SDK compatible with Dart `3.13.5` or newer
- Android Studio or Xcode for mobile development
- A connected emulator or physical device

### Run the application

```bash
flutter pub get
flutter run
```

### Validate the project

```bash
flutter analyze
flutter test
```

`flutter analyze` is currently clean. The repository also contains an older
placeholder widget test that needs a `main()` test entry point before the full
test command can pass.

## What I Learned

This project provided practical experience with:

- Building reusable Flutter pages and widgets
- Designing layouts from a complete UI/UX flow
- Managing application state with BLoC
- Separating entities, use cases, repositories, and data sources
- Using dependency injection to keep features testable
- Implementing navigation with nested shell routes
- Validating forms and handling asynchronous operations
- Modeling relational data for users, products, orders, and order items
- Filtering database results by the authenticated user
- Handling SQLite schema migrations
- Persisting profile image paths
- Supporting runtime theme and font-size changes
- Debugging runtime failures through logs and Flutter tooling

## Roadmap to Production

The local SQLite implementation is intentionally useful for development and
learning, but a production e-commerce application needs a secure, scalable
backend.

### Node.js backend

- Build a REST or GraphQL API with Node.js
- Add controllers, services, repositories, and validation
- Implement secure authentication with access and refresh tokens
- Add role-based access for customers and administrators
- Move product, cart, checkout, and order logic to the server
- Add API documentation and contract tests

### PostgreSQL database

- Replace local-only persistence with PostgreSQL
- Design normalized production schemas and indexes
- Add migrations and seed data
- Enforce server-side ownership of orders and user data
- Add transactions for checkout and order creation
- Store profile images in object storage instead of the local device

### Production readiness

- Add automated unit, integration, and end-to-end tests
- Add CI/CD pipelines
- Add structured logging and monitoring
- Add rate limiting, input sanitization, and security headers
- Add payment-provider integration
- Add push notifications and email notifications
- Containerize the backend with Docker
- Deploy the API and PostgreSQL with backups and environment-based secrets

## Project Status

This is an actively evolving learning project. The Flutter client contains
the core shopping experience and local data flow. The planned Node.js and
PostgreSQL backend will transform it into a production-ready, multi-user
e-commerce platform.

## License

This project is intended for educational and portfolio development.
