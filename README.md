# urwaypayment

A Urway is a payment gateway with payment solutions in Flutter.
This Flutter plugin provide merchants to easy and hasslefree integration with Urway Payment gateway API's.

## Getting Started

Import the package to your pubspec.yaml to use it:

    ...
    dependencies:
    ...
    urwaypayment: ^2.0.3   
    ...
    ...

## Addition Configuration for performing transactions.

Configure Terminal Id, Terminal Password, Merchant key and URL into appconfig.json file. 
And place the file into application asset folder.

## Permission 
You need to put the following implementations in Android and iOS respectively.

Android
  -Make sure to add this line android:usesCleartextTraffic="true" in your <project-directory>/android/app/src/main/AndroidManifest.xml under application like this.

        <application
        android:usesCleartextTraffic="true">
        </application>

Required Permissions are:

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />

iOS
    Add following code in your <project-directory>/ios/Runner/Info.plist
    
        <key>NSAppTransportSecurity</key>
        <dict>
        <key>NSAllowsArbitraryLoads</key> <true/>
        </dict>
        <key>io.flutter.embedded_views_preview</key> <true/> 