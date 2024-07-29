import 'package:flutter_test/flutter_test.dart';
import 'package:fps_payment_code/fps_payment_code.dart';

void main() {
  group('QRCodeGenerator', () {
    final generator = FPSCodeGenerator();

    test('Generate QR Code with phone number', () {
      final output = generator.generate(
        fpsType: FpsType.phoneNumber,
        phoneNumber: '+852-92570683',
        currency: 'HKD',
      );
      expect(output, isNotNull);
      print('QR Code (Phone Number): $output');
    });

    test('Generate QR Code with FPS ID', () {
      final output = generator.generate(
        fpsType: FpsType.id,
        fpsId: '1234567',
        currency: 'HKD',
      );
      expect(output, isNotNull);
      print('QR Code (FPS ID): $output');
    });

    test('Generate QR Code with email', () {
      final output = generator.generate(
        fpsType: FpsType.email,
        email: 'example@example.com',
        currency: 'HKD',
      );
      expect(output, isNotNull);
      print('QR Code (Email): $output');
    });

    test('Generate QR Code with additional data', () {
      final additionalData = FPSCodeAdditionalData(
        billNumber: '12345',
        mobileNumber: '555-1234',
        storeLabel: 'My Store',
        loyaltyNumber: 'LOY123',
      );
      final output = generator.generate(
        fpsType: FpsType.id,
        fpsId: '1234567',
        currency: 'HKD',
        additionalData: additionalData,
      );
      expect(output, isNotNull);
      print('QR Code (With Additional Data): $output');
    });

    test('Generate QR Code with amount and merchant name', () {
      final output = generator.generate(
        fpsType: FpsType.phoneNumber,
        phoneNumber: '+852-92570683',
        currency: 'HKD',
        amount: '100.00',
        merchantName: 'Merchant',
      );
      expect(output, isNotNull);
      print('QR Code (With Amount and Merchant Name): $output');
    });

    test('Generate QR Code with invalid FPS ID', () {
      final output = generator.generate(
        fpsType: FpsType.id,
        fpsId: '',
        currency: 'HKD',
      );
      expect(output, isNull);
      print('QR Code (Invalid FPS ID): $output');
    });

    test('Generate QR Code with conflicting additional data', () {
      final additionalData = FPSCodeAdditionalData(
        billNumber: '12345',
        referenceLabel: 'REF123',
      );
      final output = generator.generate(
        fpsType: FpsType.id,
        fpsId: '1234567',
        currency: 'HKD',
        additionalData: additionalData,
      );
      expect(output, isNull);
      print('QR Code (Conflicting Additional Data): $output');
    });
  });
}
