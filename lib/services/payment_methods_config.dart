class PaymentMethodsConfig {
  static final Map<String, dynamic> paymentMethods = {
    "groups": [
      {
        "name": "Credit Card",
        "types": ["visa", "mc", "amex"],
      },
    ],
    "paymentMethods": [
      {
        "details": [
          {"key": "encryptedCardNumber", "type": "cardToken"},
          {"key": "encryptedSecurityCode", "type": "cardToken"},
          {"key": "encryptedExpiryMonth", "type": "cardToken"},
          {"key": "encryptedExpiryYear", "type": "cardToken"},
          {"key": "holderName", "optional": true, "type": "text"},
        ],
        "name": "Credit Card",
        "type": "scheme",
      },
    ],
  };
}
