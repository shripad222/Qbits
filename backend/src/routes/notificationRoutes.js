import express from "express";
import { supabase } from "../supabaseClient.js";

const router = express.Router();

router.post("/add-notification", async (req, res) => {
  try {
    const { type, title, message, time, priority, sender, receiver } = req.body;

    // Insert into Supabase table
    const { data, error } = await supabase
      .from("notifications")
      .insert([
        {
          type,
          title,
          message,
          time,
          priority,
          sender: sender ? parseInt(sender) : null,
          receiver: receiver ? parseInt(receiver) : null,
        },
      ]);

    if (error) throw error;

    res.json({ success: true, notification: data[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
