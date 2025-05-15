<p align="center">
   <img title="Zainpay" height="100" src="https://github.com/shahidsani/zainpay-flutter-sdk/blob/main/zainpay.png" width="50%"/>
</p>

# Zainpay Flutter SDK

A modern, intuitive Flutter SDK for integrating Zainpay payment gateway into your Flutter applications.

[![Pub Version](https://img.shields.io/pub/v/zainpay)](https://pub.dev/packages/zainpay)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Table of Contents

1. [Features](#features)
2. [Requirements](#requirements)
3. [Installation](#installation)
4. [Usage](#usage)
   - [Quick Start](#quick-start)
   - [Advanced Usage](#advanced-usage)
   - [Customization](#customization)
5. [API Reference](#api-reference)
6. [Example App](#example-app)
7. [Troubleshooting](#troubleshooting)
8. [License](#license)

## Features

- 🚀 **Easy Integration**: Simple API for quick implementation
- 💳 **Multiple Payment Methods**: Card payments, bank transfers, and more
- 🎨 **Customizable UI**: Adapt the payment UI to match your app's design
- 🔒 **Secure**: Built with security best practices
- 📱 **Responsive**: Works on all screen sizes
- 🌐 **Test Mode**: Test your integration before going live

## Requirements

1. **Zainpay Account**: Sign up at [Zainpay](https://zainpay.ng) to get your API keys
2. **Flutter**: SDK version 3.0.0 or higher
3. **Dart**: SDK version 3.0.0 or higher

## Installation

Add Zainpay to your `pubspec.yaml` file:

```yaml
dependencies:
  zainpay: ^0.2.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Quick Start

The simplest way to integrate Zainpay is using the static `startPayment` method:

```dart
import 'package:flutter/material.dart';
import 'package:zainpay/zainpay.dart';

Future<void> makePayment() async {
  final response = await Zainpay.startPayment(
    context: context,
    publicKey: 'YOUR_PUBLIC_KEY',
    fullName: 'John Doe',
    email: 'john.doe@example.com',
    mobileNumber: '08012345678',
    amount: '5000',
    zainboxCode: 'YOUR_ZAINBOX_CODE',
    callBackUrl: 'https://your-website.com/callback',
    isTest: true, // Set to false for production
  );

  if (response != null) {
    // Payment successful
    print('Payment successful: ${response.toJson()}');
  } else {
    // Payment failed or was cancelled
    print('Payment failed or cancelled');
  }
}
```

### Advanced Usage

For more control over the payment process, you can use the individual components:

#### Creating a Virtual Account for Bank Transfer

```dart
final virtualAccountResponse = await Zainpay.createVirtualAccount(
  publicKey: 'YOUR_PUBLIC_KEY',
  fullName: 'John Doe',
  email: 'john.doe@example.com',
  mobileNumber: '08012345678',
  amount: 5000,
  zainboxCode: 'YOUR_ZAINBOX_CODE',
  isTest: true,
);

if (virtualAccountResponse != null) {
  final accountNumber = virtualAccountResponse.data?.accountNumber;
  final bankName = virtualAccountResponse.data?.bankName;

  // Display account details to the user
  print('Bank: $bankName, Account Number: $accountNumber');
}
```

#### Checking Virtual Account Balance

```dart
final balanceResponse = await Zainpay.checkVirtualAccountBalance(
  publicKey: 'YOUR_PUBLIC_KEY',
  accountNumber: 'ACCOUNT_NUMBER',
  fullName: 'John Doe',
  email: 'john.doe@example.com',
  mobileNumber: '08012345678',
  amount: 5000,
  zainboxCode: 'YOUR_ZAINBOX_CODE',
  isTest: true,
);

if (balanceResponse != null) {
  final balance = balanceResponse.data?.balanceAmount;
  print('Account Balance: $balance');
}
```

### Customization

You can customize the payment UI by providing a custom theme:

```dart
final response = await Zainpay.startPayment(
  context: context,
  publicKey: 'YOUR_PUBLIC_KEY',
  // ... other parameters
  theme: ThemeData(
    primaryColor: Colors.purple,
    colorScheme: ColorScheme.light(
      primary: Colors.purple,
      secondary: Colors.purpleAccent,
    ),
    // ... other theme properties
  ),
);
```

### Legacy Usage

For backward compatibility, you can still use the original approach:

```dart
final Zainpay zainpay = Zainpay(
    context: context,
    fullName: 'John Doe',
    email: 'john.doe@example.com',
    publicKey: 'YOUR_PUBLIC_KEY',
    callBackUrl: 'https://your-website.com/callback',
    mobileNumber: '08012345678',
    zainboxCode: 'YOUR_ZAINBOX_CODE',
    transactionRef: 'YOUR_TRANSACTION_REF',
    amount: '5000',
    isTest: true
);

final PaymentResponse? response = await zainpay.charge();

if (response != null) {
    print('Payment successful: ${response.toJson()}');
} else {
    print('Payment failed or cancelled');
}
```

## API Reference

### Zainpay

The main class for interacting with the Zainpay payment gateway.

#### Methods

- `static Future<PaymentResponse?> startPayment({...})`: Starts a payment transaction
- `static Future<VirtualAccountResponse?> createVirtualAccount({...})`: Creates a virtual account for bank transfer
- `static Future<VirtualAccountBalanceResponse?> checkVirtualAccountBalance({...})`: Checks the balance of a virtual account

### Models

- `PaymentRequest`: Represents a payment request
- `VirtualAccountRequest`: Represents a request to create a virtual account
- `PaymentResponse`: Response from a payment transaction
- `VirtualAccountResponse`: Response from creating a virtual account
- `VirtualAccountBalanceResponse`: Response from checking a virtual account balance

### Widgets

- `ZainpayButton`: A styled button for Zainpay
- `PaymentMethodCard`: A card widget for displaying a payment method

## Example App

Check out the [example app](https://github.com/itcglobal/zainpay/tree/main/example) for a complete implementation.

To run the example app:

```bash
cd example
flutter pub get
flutter run
```

## Troubleshooting

### Common Issues

1. **Payment Initialization Failed**: Ensure your API keys are correct and you have an active Zainpay account.
2. **Card Payment Failed**: Check that the test card details are valid if you're in test mode.
3. **Bank Transfer Not Working**: Ensure the virtual account was created successfully.

### Getting Help

If you encounter any issues, please:

1. Check the [example app](https://github.com/itcglobal/zainpay/tree/main/example) for reference
2. Open an issue on [GitHub](https://github.com/itcglobal/zainpay/issues)
3. Contact [Zainpay Support](https://zainpay.ng/contact)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) [Zainpay](https://zainpay.ng)
