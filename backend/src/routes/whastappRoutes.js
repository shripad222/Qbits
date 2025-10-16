import express from "express";
import dotenv from "dotenv";
import twilio from "twilio";

dotenv.config();

const router = express.Router();


const client = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);

router.post("/send-whatsapp", async (req, res) => {
  try {
    const { to, message } = req.body;

    const result = await client.messages.create({
      from: "whatsapp:+14155238886", // Twilio Sandbox number
      to: `whatsapp:${to}`,
      body: message,
    });

    res.json({ success: true, sid: result.sid });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
