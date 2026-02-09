# Gaurikeerthana Residency App

A complete Flutter application for room bookings, payment management, and admin confirmations.

## 🚀 Features
- **User App**: Auth, Booking Request, Payment Upload, Status Tracking.
- **Admin Panel**: Dashboard, Real-time Booking List, Approval System.
- **Backend**: Firebase Authentication, Firestore, Storage, Cloud Messaging for notifications.

## 🛠️ Setup Instructions

### 1. Firebase Configuration
1. Go to [Firebase Console](https://console.firebase.google.com/).
2. Create a new project: **Gaurikeerthana Residency**.
3. Add an **Android App**:
   - Package name: `com.example.gaurikeerthana_residency` (Update in `android/app/build.gradle`).
   - Download `google-services.json` and place it in `android/app/`.
4. Enable **Authentication**:
   - Email/Password and Phone.
5. Enable **Cloud Firestore**:
   - Use the rules provided in `firestore.rules`.
6. Enable **Firebase Storage**:
   - Create folders `id_proofs` and `payments`.
7. **Important**: To enable Admin access, manually update a user document in Firestore by adding `isAdmin: true`.

### 2. Website Integration
To connect your existing website:
1. Initialize Firebase JS SDK on your website.
2. When the booking form is submitted, use `firebase.firestore().collection('bookings').add({...})`.
3. Use the same schema as defined in `lib/models/booking.dart`.

### 3. Running the App
```powershell
flutter pub get
flutter run
```

## 📂 Architecture (MVC-ish)
- **Models**: Data structures for Users and Bookings.
- **Services**: Low-level logic for Auth, Firestore, and Storage.
- **Providers**: State management using the `provider` package.
- **Screens**: UI layer for different app sections.

## 🔔 Notifications
The app uses **Firebase Cloud Messaging**. 
- To send notifications when a booking is created, you can set up a **Firebase Cloud Function** that triggers on Firestore document creation.
