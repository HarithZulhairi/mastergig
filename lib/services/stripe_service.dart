import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class StripeService {
  static bool _initialized = false;
  static String? _stripeSecretKey;
  static const String _stripeUrl = 'https://api.stripe.com/v1/payment_intents';

  static Future<void> initialize() async {
  try {
    // For web
    await dotenv.load(fileName: 'assets/.env');
    // OR if you put it in web folder
    // await dotenv.load(fileName: 'web/.env');
    
    final publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
    if (publishableKey == null) {
      throw Exception('Stripe publishable key not found');
    }

    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
    _initialized = true;
  } catch (e) {
    _initialized = false;
    rethrow;
  }
}

  static bool get isInitialized => _initialized;

  static Future<String?> createPaymentIntent(double amount, String currency) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-firebase-function-url/createPaymentIntent'),
        body: jsonEncode({
          'amount': amount,
          'currency': currency,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['clientSecret'];
      } else {
        throw Exception('Failed to create payment intent');
      }
    } catch (e) {
      print('Payment intent error: $e');
      rethrow;
    }
  }

  static Future<bool> confirmPayment(String clientSecret) async {
  try {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'MasterGig Workshop',
        appearance: PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(
            primary: Color(0xFFFFF18E),
          ),
        ),
        googlePay: PaymentSheetGooglePay(  // Moved outside appearance
          merchantCountryCode: 'MY',
          testEnv: true,
        ),
      ),
    );
    await Stripe.instance.presentPaymentSheet();
    return true;
  } catch (e) {
    print('Payment error: $e');
    return false;
  }
}
}