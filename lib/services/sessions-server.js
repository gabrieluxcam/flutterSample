// sessions-server.js  ─────────────────────────────────────────────
// biome-ignore lint/style/useNodejsImportProtocol: <explanation>
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../.env') });
console.log('API key →', (process.env.ADYEN_API_KEY || '⛔').slice(0, 6));
console.log('Client key →', (process.env.ADYEN_CLIENT_KEY || '⛔').slice(0, 6));
console.log('Merchant →', process.env.ADYEN_MERCHANT || '⛔');
const express = require('express');
const axios = require('axios');
const app = express().use(express.json());

const checkout = axios.create({
  baseURL: 'https://checkout-test.adyen.com/v71',
  headers: {
    'X-API-Key': process.env.ADYEN_API_KEY,
    'Content-Type': 'application/json',
  },
});

app.post('/sessions', async (_, res) => {
  try {
    const { data } = await checkout.post('/sessions', {
      amount: { currency: 'EUR', value: 0 }, // €0 ⇒ no real auth
      merchantAccount: process.env.ADYEN_MERCHANT,
      // biome-ignore lint/style/useTemplate: <explanation>
      reference: 'DROPIN-DUMMY-' + Date.now(),
      returnUrl: 'myapp://adyen',
    });
    res.json(data); // ➜  { id, sessionData, ... }
  } catch (e) {
    console.error(e.response?.data || e.message);
    res.status(500).json({ error: 'sessions call failed' });
  }
});

app.listen(3000, () => console.log('Session stub listening on :3000'));
