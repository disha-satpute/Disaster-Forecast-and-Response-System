import express from "express";
import pool from "../db.js";

const router = express.Router();

// ✅ Get reports by user_id
router.get("/reports/:user_id", async (req, res) => {
  const { user_id } = req.params;

  try {
    const result = await pool.query(
      "SELECT * FROM reports WHERE user_id=$1 ORDER BY id DESC",
      [user_id]
    );
    
    res.json(result.rows);
  } catch (err) {
    console.error("❌ Error fetching reports:", err);
    res.status(500).json({ error: "Server Error" });
  }
});

// ✅ Add new disaster report
router.post("/reports", async (req, res) => {
  try {
    const { user_id, location, disaster_type, description } = req.body;

    const result = await pool.query(
      `INSERT INTO reports (user_id, location, disaster_type, description)
       VALUES ($1, $2, $3, $4) RETURNING *`,
      [user_id, location, disaster_type, description]
    );

    res.json(result.rows[0]);
  } catch (err) {
    console.error("❌ Error adding report:", err);
    res.status(500).json({ error: "Failed to add report" });
  }
});

export default router;
