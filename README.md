#fps_payment_code

Generate FPS payment code.


## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: | :-: | :---: | :-----: |
|   ✅    | ✅  |  ✅   | ✅  |  ✅   |   ✅    |

## Requirements

- Flutter >=3.3.0
- Dart >=2.18.0 <4.0.0
- iOS >=12.0
- MacOS >=10.14
- Android `compileSDK` 34
- Java 17
- Android Gradle Plugin >=8.3.0
- Gradle wrapper >=8.4


# Usage

Import `package:fps_payment_code/fps_payment_code.dart`, instantiate `FPSCodeGenerator`
and use the Android and iOS, Web generator to generate payment code.

Example:

```dart

import 'package:fps_payment_code/fps_payment_code.dart';

FPSCodeGenerator generator = FPSCodeGenerator();

var paymentCode = generator.generate(
  fpsType: FpsType.id, // or FpsType.phoneNumber, FpsType.email
  fpsId: '1234567',
  currency: 'HKD',
  amount: '100',
  merchantName: 'Your Merchant Name',
  additionalData: FPSCodeAdditionalData(
    billNumber: '12345',
    mobileNumber: '98765432',
  ),
);

print(paymentCode);

```


```dart

import 'package:fps_payment_code/fps_payment_code.dart';

FPSCodeGenerator generator = FPSCodeGenerator();

var paymentCode = generator.generate(
  fpsType: FpsType.phoneNumber,
  phoneNumber: '+852-92570683',
  currency: 'HKD',
  amount: '100.00',
);

print(paymentCode);

```

# Parameters

## FPSCodeGenerator
- fpsType: Type of payment identifier (phone number, ID, or email).
- fpsId: The payment identifier (if fpsType is id).
- phoneNumber: The user's phone number (if fpsType is phoneNumber).
- email: The user's email address (if fpsType is email).
- currency: The currency code (e.g., HKD).
- amount: The transaction amount.
- merchantName: The name of the merchant.
- additionalData: Optional additional data for the transaction.

## FPSCodeAdditionalData
- billNumber: Up to 25 characters.
- mobileNumber: Up to 25 characters.
- storeLabel: Up to 25 characters.
- loyaltyNumber: Up to 25 characters.
- referenceLabel: Up to 25 characters.
- customerLabel: Up to 25 characters.
- terminalLabel: Up to 25 characters.
- purposeOfTransaction: Up to 25 characters.
- additionalConsumerDataRequest: Up to 25 characters.


#FPS codes segment:
* Transaction Types
    * Supports three types of payment identifiers: phoneNumber, id, and email, allowing flexibility in how users can receive payments.
* Currency Support (A numeric code based on [ISO 4217])
    * The CurrencyCode enum includes a comprehensive list of currencies, ensuring users can specify the appropriate currency for their transactions.
* Merchant
    * Merchant detail includes country, city and merchant name.
* Additional Data Handling
    * The FPSCodeAdditionalData class allows for optional fields like bill numbers, store labels, and customer labels, enhancing transaction details while ensuring that certain fields (like bill number and reference label) cannot coexist.
* Validation Checks(CRC based on [ISO/IEC 13239] using the polynomial '1021' (hex) and initial value 'FFFF' (hex))
    * The code includes validation checks to ensure that required fields are present and correctly formatted.
  

# License
This project is licensed under the MIT License. See the LICENSE file for details.

# Contributing
Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

# Contact
For any inquiries, please contact [paco89lol@gmail.com].