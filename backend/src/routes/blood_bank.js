import express from "express";
import { supabase } from "../supabaseClient.js";

const router = express.Router();

// Get all blood banks
router.get("/get-all-bloodbanks", async (req, res) => {
  try {
    console.log("Getting all blood banks");
    
    const { data, error } = await supabase
      .from("blood_bank")
      .select("*")
      .order('created_at', { ascending: false });

    if (error) {
      console.error("Supabase error:", error);
      throw error;
    }

    res.json({ 
      success: true, 
      bloodBanks: data,
      count: data.length 
    });

  } catch (err) {
    console.error("Error fetching blood banks:", err);
    res.status(500).json({ 
      success: false, 
      error: err.message 
    });
  }
});

// Get single blood bank by ID
router.get("/get-bloodbank/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const { data, error } = await supabase
      .from("blood_bank")
      .select("*")
      .eq("id", id)
      .single();

    if (error) throw error;

    if (!data) {
      return res.status(404).json({ 
        success: false, 
        error: "Blood bank not found" 
      });
    }

    res.json({ success: true, bloodBank: data });

  } catch (err) {
    console.error(err);
    res.status(500).json({ 
      success: false, 
      error: err.message 
    });
  }
});

// Search blood banks with filters
router.get("/search-bloodbanks", async (req, res) => {
  try {
    const { city, state, donationCamp } = req.query;

    let query = supabase.from("blood_bank").select("*");

    // Filter by city/state in location JSONB
    if (city) {
      query = query.ilike('location->city', `%${city}%`);
    }
    if (state) {
      query = query.ilike('location->state', `%${state}%`);
    }

    // Filter by donation camp availability
    if (donationCamp !== undefined) {
      query = query.eq('donation_camp', donationCamp === 'true');
    }

    const { data, error } = await query.order('created_at', { ascending: false });

    if (error) throw error;

    res.json({ 
      success: true, 
      bloodBanks: data,
      count: data.length 
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ 
      success: false, 
      error: err.message 
    });
  }
});

export default router;
