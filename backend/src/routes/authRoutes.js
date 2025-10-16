import express from "express";
import multer from "multer";
import bcrypt from "bcryptjs";
import { supabase } from "../supabaseClient.js"; // your client file
const router = express.Router();

// Setup multer for file uploads (in memory)
const upload = multer({ storage: multer.memoryStorage() });

router.post(
  "/add-hospital",
  upload.fields([
    { name: "scanned_copy", maxCount: 1 },
    { name: "profile_pic", maxCount: 1 },
  ]),
  async (req, res) => {
    try {
      const {
        name,
        lic_no,
        type,
        location,
        contact_no,
        email,
        internal_bb,
      } = req.body;

      console.log("called the 2nd shit")

      // Upload scanned PDF
      let scannedUrl = null;
      if (req.files["scanned_copy"]) {
        const file = req.files["scanned_copy"][0];
        const { data, error } = await supabase.storage
          .from("hospital_reg_scan")
          .upload(`${Date.now()}_${file.originalname}`, file.buffer, {
            contentType: file.mimetype,
            upsert: true,
          });
        if (error) throw error;
        scannedUrl = supabase.storage
          .from("hospital_reg_scan")
          .getPublicUrl(data.path).data.publicUrl;
      }

      // Upload profile picture
      let profileUrl = null;
      if (req.files["profile_pic"]) {
        const file = req.files["profile_pic"][0];
        const { data, error } = await supabase.storage
          .from("hospital_profile")
          .upload(`${Date.now()}_${file.originalname}`, file.buffer, {
            contentType: file.mimetype,
            upsert: true,
          });
        if (error) throw error;
        profileUrl = supabase.storage
          .from("hospital_profile")
          .getPublicUrl(data.path).data.publicUrl;
      }

      // Insert into Supabase table
      const { data, error } = await supabase
        .from("hospital")
        .insert([
          {
            name,
            lic_no,
            type,
            scanned_copy_url: scannedUrl,
            location: JSON.parse(location), // expect JSON string in request
            contact_no,
            email: email || null,
            internal_bb: internal_bb === "true", // convert string to bool
            profile_pic: profileUrl,
          },
        ],
          {
            returning: "representation"
          }
        );

      if (error) throw error;

      if (!data || data.length === 0) {
        return res.json({ success: true, hospital: null });
      }

     res.json({ success: true, hospital: data[0] });

    } catch (err) {
      console.error(err);
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

router.post(
  "/add-blood-bank",
  upload.fields([
    { name: "profile_pic", maxCount: 1 },
    { name: "scanned_copy", maxCount: 1 },
  ]),
  async (req, res) => {
    try {
      const {
        name,
        parent_org,
        lic_no,
        accreditation,
        location,
        contact_no,
        email,
        operating_hours,
        extra_services_offered,
        donation_camp,
        service_area,
      } = req.body;

      // Upload profile picture
      let profileUrl = null;
      if (req.files["profile_pic"]) {
        const file = req.files["profile_pic"][0];
        const { data, error } = await supabase.storage
          .from("blood_bank_profile_pic")
          .upload(`${Date.now()}_${file.originalname}`, file.buffer, {
            contentType: file.mimetype,
            upsert: true,
          });
        if (error) throw error;
        profileUrl = supabase.storage
          .from("blood_bank_profile_pic")
          .getPublicUrl(data.path).data.publicUrl;
      }

      // Upload scanned PDF
      let scannedUrl = null;
      if (req.files["scanned_copy"]) {
        const file = req.files["scanned_copy"][0];
        const { data, error } = await supabase.storage
          .from("blood_bank_reg_scan")
          .upload(`${Date.now()}_${file.originalname}`, file.buffer, {
            contentType: file.mimetype,
            upsert: true,
          });
        if (error) throw error;
        scannedUrl = supabase.storage
          .from("blood_bank_reg_scan")
          .getPublicUrl(data.path).data.publicUrl;
      }

      // Prepare arrays
      const extraServices = extra_services_offered
        ? JSON.parse(extra_services_offered)
        : [];
      const serviceArea = service_area ? JSON.parse(service_area) : [];

      // Insert into Supabase table
      const { data, error } = await supabase
        .from("blood_bank")
        .insert([
          {
            profile_pic: profileUrl,
            name,
            parent_org,
            lic_no,
            accreditation,
            scanned_url: scannedUrl,
            location: JSON.parse(location),
            contact_no,
            email,
            operating_hours,
            extra_services_offered: extraServices,
            donation_camp: donation_camp === "true",
            sevice_area: serviceArea,
          },
        ], { returning: "representation" });

      if (error) throw error;

      res.json({ success: true, blood_bank: data && data[0] ? data[0] : null });
    } catch (err) {
      console.error(err);
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

router.post(
  "/add-donor",
  upload.single("profile_pic"),
  async (req, res) => {
    try {
      const {
        first_name,
        last_name,
        mobile_no,
        email,
        password,
        blood_group,
        location,
        screening_ques,
        date_of_last_donation,
        live_location,
      } = req.body;

      console.log("Called this shit")

      // Encrypt password
      const hashedPassword = await bcrypt.hash(password, 10);

      // Upload profile picture to donor_profile_pic bucket
      let profileUrl = null;
      if (req.file) {
        const file = req.file;
        const { data, error } = await supabase.storage
          .from("donor_profile_pic")
          .upload(`${Date.now()}_${file.originalname}`, file.buffer, {
            contentType: file.mimetype,
            upsert: true,
          });

        if (error) throw error;

        profileUrl = supabase.storage
          .from("donor_profile_pic")
          .getPublicUrl(data.path).data.publicUrl;
      }

      // Insert into donor table
      const { data, error } = await supabase
        .from("donor")
        .insert([
          {
            profile_pic: profileUrl,
            first_name,
            last_name,
            mobile_no,
            email,
            pasword: hashedPassword, // note: table column is spelled "pasword"
            blood_group,
            location: JSON.parse(location),
            screening_ques,
            date_of_last_donation,
            live_location: live_location ? JSON.parse(live_location) : null,
          },
        ]);

      if (error) throw error;

      res.json({ success: true, donor: data[0] });
    } catch (err) {
      console.error(err);
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

export default router;
