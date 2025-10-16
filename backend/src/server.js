import express from 'express';
import cors from 'cors';
import authRoutes from './routes/authRoutes.js';
import notificationRoutes from './routes/notificationRoutes.js';
import campRoutes from './routes/campsRoutes.js';
import whatsappRoutes from './routes/whastappRoutes.js';

import dotenv from "dotenv";
dotenv.config(); // looks in the same folder by default

const app = express()
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors()); // Enable Cross-Origin Resource Sharing
app.use(express.json()); // To parse JSON bodies from requests

app.use('/api/auth', authRoutes)
app.use('/', notificationRoutes)
app.use('/', campRoutes)
app.use('/', whatsappRoutes)

// server.js (or in a new routes file)
app.get('/api/test', (req, res) => {
  res.json({ success: true, message: 'Express is working!' });
});


app.listen(PORT, () => {
  console.log(`Server is listening on http://localhost:${PORT}`)
})

