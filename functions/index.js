const functions = require('firebase-functions');
const Stripe = require('stripe');
const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

exports.createPaymentIntent = functions.https.onRequest(async (req, res) => {
  try {
    const { amount, currency } = req.body;
    
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount * 100), // Convert to cents
      currency: currency.toLowerCase(),
    });

    res.status(200).json({
      clientSecret: paymentIntent.client_secret
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});