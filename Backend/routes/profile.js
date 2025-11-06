import express from "express";
import pool from "../db.js";
import { verifyToken } from "../middleware/authMiddleware.js";

const router = express.Router();

//==========================================
//Update the profile
//==========================================
router.put("/update", verifyToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const { phone, location, region, emergency_contact } = req.body;

    await pool.query(
      `UPDATE users SET phone = $1, location = $2, region = $3, emergency_contact = $4 
       WHERE id = $5`,
      [phone, location, region, emergency_contact, userId]
    );

    res.json({ success: true, message: "Profile updated successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Server error" });
  }
});


//==========================================
//delete the profile
//==========================================
router.delete("/delete", verifyToken, async (req, res) => {
  try {
    const userId = req.user.id;
    await pool.query("DELETE FROM users WHERE id = $1", [userId]);
    res.status(200).json({ success: true, message: "User deleted successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Server error" });
  }
});

// ==========================================
// @route   GET /api/profile/me
// @desc    Fetch user profile using JWT token
// @access  Private
// ==========================================
router.get("/me", verifyToken, async (req, res) => {
  try {
    const userId = req.user.id;

    const userQuery = await pool.query(
      `SELECT id, name, email, region, location, phone, emergency_contact, role, created_at 
       FROM users WHERE id = $1`,
      [userId]
    );

    if (userQuery.rows.length === 0) {
      return res.status(404).json({ success: false, message: "User not found" });
    }

    // Optional: also fetch profile details
    const profileQuery = await pool.query(
      "SELECT profile_image, address, joined_at FROM profiles WHERE user_id = $1",
      [userId]
    );

    const user = userQuery.rows[0];
    const profile = profileQuery.rows[0] || {};

    res.status(200).json({
      success: true,
      user: {
        ...user,
        profile_image: profile.profile_image,
        address: profile.address,
        joined_at: profile.joined_at,
      },
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Server error" });
  }
});

export default router;
