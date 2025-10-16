import express from 'express';
import cors from 'cors';
import authRoutes from './routes/authRoutes.js';
import notificationRoutes from './routes/notificationRoutes.js';
import campRoutes from './routes/campsRoutes.js';

const app = express()
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors()); // Enable Cross-Origin Resource Sharing
app.use(express.json()); // To parse JSON bodies from requests

app.use('/api/auth', authRoutes)
app.use('/', notificationRoutes)
app.use('/', campRoutes)

app.listen(PORT, () => {
  console.log(`Server is listening on http://localhost:${PORT}`)
})
