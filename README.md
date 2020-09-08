# iQuote
This app creates and emails overhead-crane inspection quotes for Axiom Hoist LLC.
## Dependencies
- To build this app you must have [Flutter installed and setup](https://flutter.dev/docs/get-started/install).
- If you are building for Android you will need [Android Studio](https://developer.android.com/studio).
- If you are building for iOS you will need [Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12).
## Building: Android
1. Open this repository directory in a command terminal.
2. `$ flutter clean apk`
3. `$ flutter build apk`
4. Navigate to the output apk at `ProjectDirectory\build\app\outputs\flutter-apk\app-release.apk`.
5. Connect an android phone to your computer.
6. Copy the output apk from the Flutter build directory to the downloads directory of your phone.
7. On the android phone navigate to your downloads folder and install the apk.
## Building: iOS
1. On a mac, open this repository directory in a command terminal.
2. `$ flutter clean ios`
3. `$ flutter build ios`
4. Connect an iPhone to your mac.
5. Open `ProjectDirectory/ios/Runner.xcworkspace` in Xcode.
6. Select your iPhone in Xcode.
7. Run the app in Xcode.
