import express from "express";
import { supabase } from "../supabaseClient.js";
const router = express.Router();

router.post("/add-camp", async (req, res) => {
  try {
    const { organiser, location, time } = req.body;
    console.log('Received:', { organiser, location, time });
    
    // Transform data to match table schema
    const campData = {
      organiser: organiser.name, // Extract name from organiser object
      location: location, // Keep as JSONB (address + coordinates)
      time: `${time.date} ${time.startTime}-${time.endTime}`, // Combine into single text
      description: organiser.description || null,
      contact_information: organiser.contactPhone || null,
      email: organiser.contactEmail || null
    };

    console.log('Inserting:', campData);

    // Insert into Supabase table
    const { data, error } = await supabase
      .from("camps")
      .insert([campData])
      .select(); // ⬅️ Add .select() to return inserted data

    if (error) {
      console.error('Supabase error:', error);
      throw error;
    }

    console.log('Inserted successfully:', data);
    res.json({ success: true, camp: data[0] });
    
  } catch (err) {
    console.error('Error:', err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// Get single camp by ID
router.get("/get-camp/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { data, error } = await supabase
      .from("camps")
      .select("*")
      .eq("id", id)
      .single();
    if (error) throw error;
    res.json({ success: true, camp: data });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

router.get("/get-all-camps", async (req, res) => {
  const { data, error } = await supabase.from("camps").select("*");
  console.log("Getting all the camps");
  if (error) {
    console.error(error);
    return res.status(500).json({ success: false, error: error.message });
  }
  res.json({ success: true, camps: data });
});

export default router;
