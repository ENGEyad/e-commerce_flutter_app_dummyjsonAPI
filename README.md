# Flutter Ecommerce App with DummyJSON and MVVM

This app is a Flutter ecommerce frontend built with MVVM architecture and the DummyJSON API.

## Stack

- Flutter
- Dio
- ChangeNotifier
- MVVM
- DummyJSON REST API

## Project structure

```txt
lib/
  models/
  repositories/
  services/
  viewmodels/
  views/
```

## Architecture overview

### Models
Models map JSON responses into typed Dart objects. They should not contain UI logic or HTTP logic.

### Repositories
Repositories isolate the API details from the ViewModels. They handle network calls and response parsing.

### ViewModels
ViewModels store screen state and expose methods such as loading products, searching, refreshing session data, and managing cart state.

### Views
Views listen to ViewModels and render the UI.

## Main API resources

- `auth`
- `products`
- `carts`
- `users`
- `posts`
- `recipes`

## Auth flow

1. Call `/auth/login` with username and password.
2. Store `accessToken` and `refreshToken`.
3. Use `accessToken` for `/auth/me`.
4. Use `refreshToken` for `/auth/refresh`.

## Product flow

1. Load `/products`.
2. Search with `/products/search?q=...`.
3. Filter by category with `/products/category/{slug}`.
4. Open product details with `/products/{id}`.

## Cart flow

1. Load carts with `/carts`.
2. Load user carts with `/carts/user/{userId}`.
3. Add products using `/carts/add`.
4. Update cart using `/carts/{id}`.

## Notes

- DummyJSON simulates create/update/delete operations.
- Those actions return mock results and do not persist on the server.
- For production, separate DTOs, domain entities, and UI models.
- Use secure storage for tokens.

## Benefits of this structure

- Easy to test
- Easy to extend
- Clear separation of concerns
- Suitable for medium and large Flutter apps