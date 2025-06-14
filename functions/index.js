// functions/index.js
const functions = require('firebase-functions');
const Stripe = require('stripe');
const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(data.amount * 100), // Convert to cents
      currency: data.currency,
    });
    return { clientSecret: paymentIntent.client_secret };
  } catch (e) {
    throw new functions.https.HttpsError('internal', e.message);
  }
});