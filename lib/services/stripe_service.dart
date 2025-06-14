import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StripeService {
  static const String _stripePublishableKey = 'pk_test_51RZsuuGhg7kZxWbUakW0Kn1hQ5luQWaRKHCXJP8zb8xZZjFD0FXZbjyXMJu0oEsaoMuywzzdcafHYcOSu7Pulwka004ClWlSti';
  static const String _stripeUrl = 'https://api.stripe.com/v1/payment_intents';

  static Future<void> init() async {
    Stripe.publishableKey = _stripePublishableKey;
    await Stripe.instance.applySettings();
  }

  static Future<String?> createPaymentIntent(double amount, String currency) async {
    try {
      final response = await http.post(
        Uri.parse(_stripeUrl),
        headers: {
          'Authorization': 'Bearer YOUR_STRIPE_SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'amount': (amount * 100).toStringAsFixed(0), // in cents
          'currency': currency,
        },
      );

      return jsonDecode(response.body)['client_secret'];
    } catch (e) {
      print('Stripe Error: $e');
      return null;
    }
  }
}