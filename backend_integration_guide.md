# Backend Integration Guide

This document summarizes the data structures, endpoints, and field types required to integrate the Flutter frontend with your NestJS (or any other) backend.

## 1. Authentication Module
| Action | Endpoint | Method | Request Body (JSON) | Expected Response |
| :--- | :--- | :--- | :--- | :--- |
| **Login** | `/auth/login` | `POST` | `{"email": "string", "password": "string"}` | `{"access_token": "string"}` |
| **Register** | `/auth/register` | `POST` | `{"name": "string", "email": "string", "password": "string"}` | `{"message": "Registration success"}` |
| **Forgot Pwd** | `/auth/forgot-password` | `POST` | `{"email": "string"}` | `{"message": "Reset link sent"}` |

---

## 2. Product Management (Admin & User)
Base Path: `/products`

| Feature | Endpoint | Method | Parameters/Body | Description |
| :--- | :--- | :--- | :--- | :--- |
| **Fetch All** | `/products` | `GET` | N/A | Returns all products. |
| **Search** | `/products/search` | `GET` | `?q=query_string` | Search by name, brand, or barcode. |
| **Get Detail** | `/products/:barcode` | `GET` | `:barcode` (Path Param) | Fetch a single product by its unique barcode. |
| **Add Product**| `/products` | `POST` | `Product Model` (see below) | Add new product (Admin Only). |
| **Update** | `/products/:barcode` | `PUT` | `Product Model` (see below) | Update product details (Admin Only). |
| **Delete** | `/products/:barcode` | `DELETE` | `:barcode` (Path Param) | Remove product from database (Admin Only). |

### Product Data Model Schema
This JSON structure is shared between `GET`, `POST`, and `PUT` requests.

| Field | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `name` | `String` | Yes | Name of the product. |
| `brand` | `String` | Yes | Brand or manufacturer. |
| `category` | `String` | Yes | One of: Electrical, Plumbing, Lighting, Pipes, Bathroom Fittings. |
| `barcode` | `String` | Yes | Unique EAN/UPC barcode number. |
| `imageUrl` | `String` | No | File path or URL to product image. |
| `specifications`| `Map<String, String>` | No | Key-value pairs for technical specs (e.g. `{"Voltage": "220V"}`). |

---

## 3. Comparison & AI Module
| Action | Endpoint | Method | Request Body | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **Compare AI** | `/products/compare` | `POST` | `{"barcodes": ["123", "456"]}` | Expects AI generated recommendation text in response: `{"recommendation": "..."}` or `{"data": "..."}` |

---

## 4. Role-Based Access (Frontend Side)
To test Admin features in the frontend, use the following email:
- **Admin Email**: `nihalshareef666@gmail.com`
- **Logic**: The app checks `currentUserEmail == ADMIN_EMAIL` to show floating buttons and CRUD options.

> [!IMPORTANT]
> Ensure the backend also validates the JWT token or the Request Email to prevent unauthorized API calls from non-admin users.

---

## 5. Development Base URLs
- **Android Emulator**: `http://10.0.2.2:3000`
- **Physical Device**: `http://192.168.1.5:3000` (Update based on local IP)
- **Web/iOS Sim**: `http://localhost:3000`
