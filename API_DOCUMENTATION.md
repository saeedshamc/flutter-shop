# 📡 مستندات API

این مستندات شامل توضیحات کامل API های استفاده شده در پروژه است.

## 🔥 Firebase Services

### Authentication API

#### Sign Up
```dart
Future<UserCredential> signUpWithEmail(String email, String password)
```
**توضیح**: ثبت‌نام کاربر جدید با ایمیل و رمز عبور

**پارامترها**:
- `email`: ایمیل کاربر
- `password`: رمز عبور (حداقل 6 کاراکتر)

**خروجی**: `UserCredential` یا `FirebaseAuthException`

#### Sign In
```dart
Future<UserCredential> signInWithEmail(String email, String password)
```
**توضیح**: ورود کاربر با ایمیل و رمز عبور

#### Reset Password
```dart
Future<void> sendPasswordResetEmail(String email)
```
**توضیح**: ارسال ایمیل بازیابی رمز عبور

#### Sign Out
```dart
Future<void> signOut()
```
**توضیح**: خروج کاربر از حساب کاربری

---

### Firestore Database API

## Products Collection

### Get Products
```dart
GET /products
```
**Query Parameters**:
- `limit`: تعداد محصولات (پیش‌فرض: 20)
- `categoryId`: فیلتر بر اساس دسته‌بندی
- `minPrice`: حداقل قیمت
- `maxPrice`: حداکثر قیمت
- `sortBy`: مرتب‌سازی (newest, cheapest, mostExpensive, bestRating)

**Response**:
```json
{
  "products": [
    {
      "id": "string",
      "name": "string",
      "brand": "string",
      "description": "string",
      "price": 0,
      "discount": 0,
      "categoryId": "string",
      "images": ["string"],
      "stock": 0,
      "rating": 0,
      "isActive": true,
      "isFeatured": false,
      "createdAt": "timestamp",
      "updatedAt": "timestamp"
    }
  ]
}
```

### Get Product by ID
```dart
GET /products/{id}
```

### Add Product (Admin Only)
```dart
POST /products
```
**Body**:
```json
{
  "name": "string",
  "brand": "string",
  "description": "string",
  "price": 0,
  "discount": 0,
  "categoryId": "string",
  "images": ["string"],
  "stock": 0
}
```

### Update Product (Admin Only)
```dart
PUT /products/{id}
```

### Delete Product (Admin Only)
```dart
DELETE /products/{id}
```

---

## Categories Collection

### Get Categories
```dart
GET /categories
```

**Response**:
```json
{
  "categories": [
    {
      "id": "string",
      "name": "string",
      "icon": "string",
      "description": "string",
      "productCount": 0,
      "isActive": true,
      "createdAt": "timestamp"
    }
  ]
}
```

### Get Category by ID
```dart
GET /categories/{id}
```

### Add Category (Admin Only)
```dart
POST /categories
```

### Update Category (Admin Only)
```dart
PUT /categories/{id}
```

### Delete Category (Admin Only)
```dart
DELETE /categories/{id}
```

---

## Orders Collection

### Get Orders
```dart
GET /orders?userId={userId}
```

**Response**:
```json
{
  "orders": [
    {
      "id": "string",
      "userId": "string",
      "items": [
        {
          "productId": "string",
          "productName": "string",
          "productImage": "string",
          "quantity": 0,
          "price": 0,
          "discount": 0
        }
      ],
      "totalPrice": 0,
      "status": "pending|processing|completed|cancelled",
      "paymentMethod": "string",
      "shippingAddress": {
        "fullName": "string",
        "phone": "string",
        "address": "string",
        "city": "string",
        "state": "string",
        "postalCode": "string"
      },
      "createdAt": "timestamp"
    }
  ]
}
```

### Create Order
```dart
POST /orders
```

### Update Order Status (Admin Only)
```dart
PATCH /orders/{id}/status
```

### Cancel Order
```dart
PATCH /orders/{id}/cancel
```

---

## Users Collection

### Get Current User
```dart
GET /users/{userId}
```

**Response**:
```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "role": "admin|user",
  "photoUrl": "string",
  "phone": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Update User Profile
```dart
PUT /users/{userId}
```

---

## 🔐 Authentication Headers

برای درخواست‌های نیازمند authentication:

```
Authorization: Bearer {firebase_id_token}
```

## ⚠️ Error Codes

| کد | توضیح |
|----|-------|
| 400 | درخواست نامعتبر |
| 401 | عدم احراز هویت |
| 403 | عدم دسترسی |
| 404 | یافت نشد |
| 500 | خطای سرور |

## 📊 Rate Limiting

- **Read Operations**: 50,000 درخواست در روز (رایگان)
- **Write Operations**: 20,000 درخواست در روز (رایگان)

## 🌐 Base URLs

- **Development**: `https://dev-api.yourshop.com`
- **Staging**: `https://staging-api.yourshop.com`
- **Production**: `https://api.yourshop.com`

## 💡 نکات مهم

1. همیشه از HTTPS استفاده کنید
2. ID Token را هر ساعت refresh کنید
3. از pagination برای لیست‌های بزرگ استفاده کنید
4. Error handling مناسب پیاده‌سازی کنید
5. از caching برای بهبود performance استفاده کنید

---

**برای اطلاعات بیشتر به [Firebase Documentation](https://firebase.google.com/docs) مراجعه کنید.**

