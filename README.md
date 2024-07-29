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