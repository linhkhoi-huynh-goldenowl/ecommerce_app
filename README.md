# Flutter Ecommerce App

<p align="center">
  <a href="https://flutter.io/">
    <img src="https://storage.googleapis.com/cms-storage-bucket/ec64036b4eacc9f3fd73.svg" alt="Logo" width=72 height=72>
  </a>

  <h3 align="center">Flutter Ecommerce App</h3>

  <p align="center">
    Fork this project then start you project with a lot of stuck prepare
    <br>
    Base project made with much  :heart: . Contains CRUD, patterns, and much more!
    <br>
    <br>
    <a href="https://github.com/linhkhoi-huynh-goldenowl/ecommerce_app/issues/new">Report bug</a>
    ·
    <a href="https://github.com/linhkhoi-huynh-goldenowl/ecommerce_app/issues/new">Request feature</a>
  </p>
</p>

## Table of contents

- [How to Use](#how-to-use)
- [Dependencies](#depencencies)
- [Code structure](#code-structure)
- [Screenshot](#screenshot)
- [Github action](#github-action)

## How to Use 

1. Download or clone this repo by using the link below:
  ```
  https://github.com/linhkhoi-huynh-goldenowl/ecommerce_app.git
  ```
2. Go to project root and execute the following command in console to get the required dependencies: 

  ```
  flutter pub get 
  ```
3. Now run the generator
  ```
  flutter packages pub run build_runner build
  ```
4. Import Data
 
- [Sheets from link](https://docs.google.com/spreadsheets/d/1NvG7PEUJgIit_eUVMg_4zFnc6OY9YeHGsSccGwiHt4Y/edit?usp=sharing)

- Code for import data product in ecommerce_app/sheets_app_scripts/code.gs  
 
# Depencencies
- [equatable](https://pub.dev/packages/equatable): Simplify Equality Comparisons.
- [carousel_slider](https://pub.dev/packages/carousel_slider): A carousel slider widget.
- [intl](https://pub.dev/packages/intl): Provides internationalization and localization facilities, including message translation, plurals and genders, date/number formatting and parsing, and bidirectional text.
- [image_picker](https://pub.dev/packages/image_picker): A Flutter plugin for iOS and Android for picking images from the image library, and taking new pictures with the camera.
- [cached_network_image](https://pub.dev/packages/cached_network_image): A flutter library to show images from the internet and keep them in the cache directory.
- [shared_preferences](https://pub.dev/packages/shared_preferences): Flutter plugin for reading and writing simple key-value pairs. Wraps NSUserDefaults on iOS and SharedPreferences on Android.
- [permission_handler](https://pub.dev/packages/permission_handler): Permission plugin for Flutter. This plugin provides a cross-platform (iOS, Android) API to request and check permissions.

## Social Login
- [google_sign_in](https://pub.dev/packages/google_sign_in): A Flutter plugin for Google Sign In.
- [flutter_facebook_auth](https://pub.dev/packages/flutter_facebook_auth): The easiest way to add facebook login to your flutter app, get user information, profile picture and more. Web support included.

## Flutter Firebase
The official Firebase plugins for Flutter. authentication, storage, firestore.
- [firebase_core](https://pub.dev/packages/firebase_core): A Flutter plugin to use the Firebase Core API, which enables connecting to multiple Firebase apps.
- [firebase_auth](https://pub.dev/packages/firebase_auth): Firebase Authentication aims to make building secure authentication systems easy, while improving the sign-in and onboarding experience for end users. 
- [cloud_firestore](https://pub.dev/packages/cloud_firestore): Cloud Firestore is a flexible, scalable database for mobile, web, and server development from Firebase and Google Cloud.
- [firebase_storage](https://pub.dev/packages/firebase_storage): Cloud Storage for Firebase is a powerful, simple, and cost-effective object storage service built for Google scale. 

## State Management
State Management is still the hottest topic in Flutter Community. There are tons of choices available and it’s super intimidating for a beginner to choose one. Also, all of them have their pros and cons. So, what’s the best approach
- [flutter_bloc](https://pub.dev/packages/flutter_bloc): Widgets that make it easy to integrate blocs and cubits into Flutter. [Learn more](https://bloclibrary.dev/#/) 

## Code structure
Here is the core folder structure which flutter provides.
```
flutter-app/
|- android
|- ios
|- lib
|- modules
|- test
```
Here is the folder structure we have been using in this project

```
lib/
|- config/
  |- routes/
  |- styles/
|- dialogs/
|- modules/
  |- cubit/
  |- models/
  |- repositories/
  |- screens/
|- utils/
  |- helpers/
  |- services/
|- widgets/
|- main.dart
```

## Screenshot
![screenshot1](/assets/images/screenshots/screenshot1.png)
![screenshot2](/assets/images/screenshots/screenshot2.png)
![screenshot3](/assets/images/screenshots/screenshot3.png)

## Github Action
- Github Action only deploys to google play console when pull request has been merged.
- Version of file release will auto increase when github action deploy.
