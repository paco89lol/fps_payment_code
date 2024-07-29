library fps_payment_code;

enum CurrencyCode {
  AFN, ALL, DZD, USD, EUR, AOA, XCD, ARS, AMD, AWG,
  AUD, BHD, BDT, BBD, BYN, BZD, XOF, BMD, BTN, INR,
  BOB, BOV, BSD, CAD, KYD, XAF, CLF, CLP, CNY, COP,
  KMF, CDF, CRC, CUP, CUC, ANG, CZK, DKK, DJF, DOP,
  EGP, ERN, ETB, FJD, GEL, GHS, GIP, GBP, GMD, GNF,
  GYD, HTG, HNL, HKD, HUF, ISK, IDR, IRR, IQD, ILS,
  JMD, JPY, JOD, KZT, KES, KPW, KRW, KWD, KGS, LAK,
  LBP, LSL, LRD, LYD, CHF, MDL, MGA, MWK, MYR, MVR,
  MXN, MZN, MMK, NAD, NPR, NZD, NIO, NGN, NOK,
  OMR, PKR, PAB, PEN, PHP, ZAR, PYG, RON, RUB, RWF,
  XPF, SAR, SCR, SLE, SGD, SHP, SIT, SSP, LKR,
  SDG, SRD, SEK, TJS, TMT, TND, TRY, TWD, TZS, UGX,
  UAH, AED, UYU, UZS, VUV, VND, VEF, XDR,
  ZMW, ZWL, XAU
}

enum FpsType {
  phoneNumber,
  id,
  email
}

// remark: billNumber and referenceLabel can not be existed at the same time.
class FPSCodeAdditionalData {
  String? billNumber; // up to 25 characters
  String? mobileNumber; // up to 25 characters
  String? storeLabel; // up to 25 characters
  String? loyaltyNumber; // up to 25 characters
  String? referenceLabel; // up to 25 characters
  String? customerLabel; // up to 25 characters
  String? terminalLabel; // up to 25 characters
  String? purposeOfTransaction; // up to 25 characters
  String? additionalConsumerDataRequest; // up to 25 characters

  FPSCodeAdditionalData({this.billNumber,
    this.mobileNumber,
    this.storeLabel,
    this.loyaltyNumber,
    this.referenceLabel,
    this.customerLabel,
    this.terminalLabel,
    this.purposeOfTransaction,
    this.additionalConsumerDataRequest,
  });
//...
}

// remark: additionalData will be ignore if fpsType is equal to phoneNumber or email.
class FPSCodeGenerator {
  String? generate({
    required FpsType fpsType,
    String? phoneNumber,
    String? fpsId,
    String? email,
    required String currency,
    String? amount,
    String? merchantName,
    FPSCodeAdditionalData? additionalData,
  }) {
    String output = '';
    String subOutput = '';

    output += '00' + '02' + '01';

    //“11” for static QR Codes, “12” for dynamic QR Codes. It does not affect the functionality.
    /* Since the fps does not have expiration/timeout concept, qrcode has no point to have static or dynamic type.
     * Be my guess, it can be a huge cost to supporting dynamic Qrcode, if every users frequently create it for transaction.
     * */
    output += '01' + '02' + '12';

    if (fpsType == FpsType.id) {
      // fpsId should be 7 or 11 digits
      if (fpsId == null || fpsId.isEmpty) {
        return null;
      }
      subOutput = ('00' + '12' + 'hk.com.hkicl' + '02' + fpsId.length.toString().padLeft(2, '0') + fpsId);
      output += '26' + subOutput.length.toString().padLeft(2, '0') + subOutput;

    } else if (fpsType == FpsType.phoneNumber) {
      if (phoneNumber == null || phoneNumber.isEmpty) {
        return null;
      }
      subOutput = '00' + '12' + 'hk.com.hkicl' + '03'+ phoneNumber.length.toString().padLeft(2, '0') + phoneNumber;
      output += '26' + subOutput.length.toString().padLeft(2, '0') + subOutput;

    } else if (fpsType == FpsType.email) {
      if (email == null || email.isEmpty) {
        return null;
      }
      subOutput = ('00' + '12' + 'hk.com.hkicl' + '04' + email.length.toString().padLeft(2, '0') + email);
      output += '26' + subOutput.length.toString().padLeft(2, '0') + subOutput; // Length of the email data
    }

    output += '52' + '04' + '0000'; // Put a dummy code of “0000” in this field if the payment operator does not use this information
    output += '53' + '03' + currencyToNumeric(currency); // Currency identifier
    if (amount != null && amount.isNotEmpty) {
      output += '54' + amount.length.toString().padLeft(2, '0') + amount; // Amount
    }
    output += '58' + '02' + 'HK'; // Merchant Country(FPS only support HK region)
    if (merchantName != null && merchantName.isNotEmpty) {
      output += '59' + merchantName.length.toString().padLeft(2, '0') + merchantName;
    } else {
      output += '59' + '02' + 'NA'; // Merchant Name
    }
    output += '60' + '02' + 'HK'; // Merchant City(FPS only support HK region)

    // If FPS type is not ID, additionalData will be ignored
    if (fpsType == FpsType.id && additionalData != null) {
      // billNumber and referenceLabel can not be existed at the same time
      if (additionalData.billNumber != null && additionalData.referenceLabel != null) {
        return null;
      }

      String outputRC = '';

      String? billNumber = additionalData.billNumber;
      if (billNumber != null && billNumber.isNotEmpty) {
        outputRC += '01' + billNumber.length.toString().padLeft(2, '0') + billNumber;
      }

      String? mobileNumber = additionalData.mobileNumber;
      if (mobileNumber != null && mobileNumber.isNotEmpty) {
        outputRC += '02' + mobileNumber.length.toString().padLeft(2, '0') + mobileNumber;
      }

      String? storeLabel = additionalData.storeLabel;
      if (storeLabel != null && storeLabel.isNotEmpty) {
        outputRC += '03' + storeLabel.length.toString().padLeft(2, '0') + storeLabel;
      }

      String? loyaltyNumber = additionalData.loyaltyNumber;
      if (loyaltyNumber != null && loyaltyNumber.isNotEmpty) {
        outputRC += '04' + loyaltyNumber.length.toString().padLeft(2, '0') + loyaltyNumber;
      }

      String? referenceLabel = additionalData.referenceLabel;
      if (referenceLabel != null && referenceLabel.isNotEmpty) {
        outputRC += '05' + referenceLabel.length.toString().padLeft(2, '0') + referenceLabel;

      }

      String? customerLabel = additionalData.customerLabel;
      if (customerLabel != null && customerLabel.isNotEmpty) {
        outputRC += '06' + customerLabel.length.toString().padLeft(2, '0') + customerLabel;

      }

      String? terminalLabel = additionalData.terminalLabel;
      if (terminalLabel != null && terminalLabel.isNotEmpty) {
        outputRC += '07' + terminalLabel.length.toString().padLeft(2, '0') + terminalLabel;

      }

      String? purposeOfTransaction = additionalData.purposeOfTransaction;
      if (purposeOfTransaction != null && purposeOfTransaction.isNotEmpty) {
        outputRC += '08' + purposeOfTransaction.length.toString().padLeft(2, '0') + purposeOfTransaction;

      }

      String? additionalConsumerDataRequest = additionalData.additionalConsumerDataRequest;
      if (additionalConsumerDataRequest != null && additionalConsumerDataRequest.isNotEmpty) {
        outputRC += '09' + additionalConsumerDataRequest.length.toString().padLeft(2, '0') + additionalConsumerDataRequest;

      }

      output += '62' + outputRC.length.toString().padLeft(2, '0') + outputRC;
    }


    output += '63' + '04';
    output += getLastFourCharacters(calculateCRC(output)); // CRC


    return output;
  }

  String currencyToNumeric(String currency) {
    const Map<String, String> currencyMap = {
      'AFN': '971', 'ALL': '008', 'DZD': '012', 'USD': '840',
      'EUR': '978', 'AOA': '973', 'XCD': '951', 'ARS': '032',
      'AMD': '051', 'AWG': '533', 'AUD': '036', 'BHD': '048',
      'BDT': '050', 'BBD': '052', 'BYN': '933', 'BZD': '084',
      'XOF': '952', 'BMD': '060', 'BTN': '064', 'INR': '356',
      'BOB': '068', 'BOV': '984', 'BSD': '044', 'CAD': '124',
      'KYD': '136', 'XAF': '950', 'CLF': '990', 'CLP': '152',
      'CNY': '156', 'COP': '170', 'KMF': '174', 'CDF': '976',
      'CRC': '188', 'CUP': '192', 'CUC': '931', 'ANG': '532',
      'CZK': '203', 'DKK': '208', 'DJF': '262', 'DOP': '214',
      'EGP': '818', 'ERN': '232', 'ETB': '230', 'FJD': '242',
      'GEL': '981', 'GHS': '936', 'GIP': '292', 'GBP': '826',
      'GMD': '270', 'GNF': '324', 'GYD': '328', 'HTG': '332',
      'HNL': '340', 'HKD': '344', 'HUF': '348', 'ISK': '352',
      'IDR': '360', 'IRR': '364', 'IQD': '368', 'ILS': '376',
      'JMD': '388', 'JPY': '392', 'JOD': '400', 'KZT': '398',
      'KES': '404', 'KPW': '408', 'KRW': '410', 'KWD': '414',
      'KGS': '417', 'LAK': '418', 'LBP': '422', 'LSL': '426',
      'LRD': '430', 'LYD': '434', 'CHF': '756', 'MDL': '498',
      'MGA': '969', 'MWK': '454', 'MYR': '458', 'MVR': '462',
      'MXN': '484', 'MZN': '943', 'MMK': '104',
      'NAD': '516', 'NPR': '524', 'NZD': '554', 'NIO': '558',
      'NGN': '566', 'NOK': '578', 'OMR': '512', 'PKR': '586',
      'PAB': '590', 'PEN': '604', 'PHP': '608', 'ZAR': '710',
      'PYG': '600', 'RON': '946', 'RUB': '643', 'RWF': '646',
      'XPF': '953', 'SAR': '682', 'SCR': '690', 'SLE': '925',
      'SGD': '702', 'SHP': '654', 'SIT': '705',
      'SSP': '728', 'LKR': '144', 'SDG': '938', 'SRD': '968',
      'SEK': '752', 'TJS': '972', 'TMT': '934', 'TND': '788',
      'TRY': '949', 'TWD': '901', 'TZS': '834', 'UGX': '800',
      'UAH': '980', 'AED': '784',
      'UYU': '858', 'UZS': '860', 'VUV': '548', 'VND': '704',
      'VEF': '937', 'XDR': '960', 'ZMW': '967', 'ZWL': '932',
      'XAU': '959', // Additional currencies can be added here
    };

    return currencyMap[currency] ?? '000'; // Fallback for unknown currencies
  }

  String calculateCRC(String data) {
    int crc = 0xFFFF;
    for (int i = 0; i < data.length; i++) {
      crc ^= data.codeUnitAt(i) << 8;
      for (int j = 0; j < 8; j++) {
        if ((crc & 0x8000) != 0) {
          crc = (crc << 1) ^ 0x1021;
        } else {
          crc <<= 1;
        }
      }
    }
    return crc.toRadixString(16).padLeft(4, '0').toUpperCase();
  }

  String getLastFourCharacters(String text) {
    return text.substring(text.length - 4);
  }
}