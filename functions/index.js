const functions = require('firebase-functions');
const Stripe = require('stripe');
const cors = require('cors')({ origin: true });

const stripe = Stripe(functions.config().stripe.secret);

exports.createPaymentIntent = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    if (req.method !== 'POST') {
      return res.status(405).send('Method Not Allowed');
    }

    try {
      const { amount, currency } = req.body;
      
      const paymentIntent = await stripe.paymentIntents.create({
        amount: Math.round(amount * 100), // Convert to cents
        currency: currency.toLowerCase(),
      });

      res.status(200).json({
        clientSecret: paymentIntent.client_secret,
      });
    } catch (err) {
      console.error('Error creating payment intent:', err);
      res.status(500).json({ error: err.message });
    }
  });
});