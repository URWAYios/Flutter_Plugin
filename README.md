# urwaypayment

A Urway is a payment gateway with payment solutions in Flutter.
This Flutter plugin provide merchants to easy and hasslefree integration with Urway Payment gateway API's.

## Getting Started

Import the package to your pubspec.yaml to use it:

    ...
    dependencies:
    ...
    urwaypayment: ^2.0.4 
    ...
    ...

## Addition Configuration for performing transactions.

Configure Terminal Id, Terminal Password, Merchant key and URL into appconfig.json file. 
And place the file into application asset folder.

## Permission 
You need to put the following implementations in Android and iOS respectively.

Android

Required Permissions are:

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
