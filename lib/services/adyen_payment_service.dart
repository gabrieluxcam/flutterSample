import 'dart:io' show Platform;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';

class AdyenPaymentService {
  static const String _clientKey = 'test_BNQ6U2EPYNA2LBWFZSLEA5GPYQDQISSA';

  static Future<void> startPayment(BuildContext context, String amount) async {
    try {
      // ──────────────────────────────────────────────────────────────────
      //  Pick the correct base-URL depending on where the app is running
      // ──────────────────────────────────────────────────────────────────
      final stubUrl =
          Platform.isAndroid
              ? 'http://10.0.2.2:3000/sessions' // Android emulator
              : 'http://localhost:3000/sessions'; // iOS simulator / desktop

      // 1. Fetch a valid Session from your Node stub
      final r = await http.post(Uri.parse(stubUrl));

      if (r.statusCode != 200) {
        throw 'Session stub responded ${r.statusCode}: ${r.body}';
      }
      final data = jsonDecode(r.body) as Map<String, dynamic>;

      final sessionId = data['id'] as String?;
      final sessionData = data['sessionData'] as String?;

      if (sessionId == null || sessionData == null) {
        throw 'Stub returned malformed session: $data';
      }
      // Build the Drop-in configuration
      final dropInConfig = DropInConfiguration(
        environment: Environment.test,
        clientKey: _clientKey,
        countryCode: 'US',
        shopperLocale: 'en_US',
        amount: Amount(value: int.parse(amount), currency: 'USD'),
        cardConfiguration: const CardConfiguration(),
      );

      // Create session checkout
      final sessionCheckout = await AdyenCheckout.session.create(
        sessionId: sessionId,
        sessionData: sessionData,
        configuration: dropInConfig,
      );

      // Show the Drop-in
      final result = await AdyenCheckout.session.startDropIn(
        checkout: sessionCheckout,
        dropInConfiguration: dropInConfig,
      );

      String message;
      if (result is PaymentSessionFinished) {
        message = 'Payment completed successfully';
      } else if (result is PaymentCancelledByUser) {
        message = 'Payment was cancelled';
      } else if (result is PaymentError) {
        message = 'Payment error: ${result.reason}';
      } else {
        message = 'Payment status: unknown';
      }

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      debugPrint('Error starting payment: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to start payment: $e')));
      }
    }
  }
}
