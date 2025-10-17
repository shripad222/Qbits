import express from "express";
import { supabase } from "../supabaseClient.js";

const router = express.Router();

router.post("/add-camp", async (req, res) => {
  try {
    const { organiser, location, time } = req.body;

    // Insert into Supabase table
    const { data, error } = await supabase
      .from("camps")
      .insert([
        {
          organiser,
          location: location, // same structure as before
          time,
        },
      ]);

    if (error) throw error;

    res.json({ success: true, camp: data[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// Get single camp by ID
// router.get("/get-camp/:id", async (req, res) => {
//   try {
//     const { id } = req.params;
//
//     const { data, error } = await supabase
//       .from("camps")
//       .select("*")
//       .eq("id", id)
//       .single();
//
//     if (error) throw error;
//
//     res.json({ success: true, camp: data });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, error: err.message });
//   }
// });
// --- Get all camps ---
router.get("/get-all-camps", async (req, res) => {
  const { data, error } = await supabase.from("camps").select("*");
  if (error) {
    console.error(error);
    return res.status(500).json({ success: false, error: error.message });
  }
  res.json({ success: true, camps: data });
});export default router;
