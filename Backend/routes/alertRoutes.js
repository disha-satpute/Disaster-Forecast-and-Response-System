import express from "express";
import { pool } from "../db.js";

const router = express.Router();

// ➕ Add new disaster alert
router.post("/add-alert", async (req, res) => {
  try {
    const {
      disasterType,
      location,
      latitude,
      longitude,
      alertMessage,
      shelterInfo,
    } = req.body;

    if (!disasterType || !location || !alertMessage) {
      return res
        .status(400)
        .json({ success: false, message: "Missing required fields" });
    }

    const result = await pool.query(
      `INSERT INTO alerts (disaster_type, location, latitude, longitude, alert_message, shelter_info, status)
       VALUES ($1, $2, $3, $4, $5, $6, 'Active') RETURNING *`,
      [disasterType, location, latitude, longitude, alertMessage, shelterInfo]
    );

    res.status(201).json({
      success: true,
      message: "Alert added successfully",
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Server error" });
  }
});

// 📋 Get all alerts
router.get("/get-alerts", async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM alerts ORDER BY timestamp DESC"
    );
    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Database error" });
  }
});

export default router;
