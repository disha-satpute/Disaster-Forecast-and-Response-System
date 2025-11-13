import express from "express";
import pool from "../db.js";
// import twilio from "twilio";  // 🔐 Uncomment if integrating Twilio later

const router = express.Router();

/**
 * POST /api/sms/send-sms
 * Send (or log) an SMS alert to all registered users.
 */
router.post("/send-sms", async (req, res) => {
  try {
    const { disasterType, message, shelterInfo } = req.body;

    // ✅ Input validation
    if (!disasterType || !message) {
      return res.status(400).json({
        success: false,
        message: "Missing required fields: disasterType or message",
      });
    }

    // ✅ Save SMS alert to PostgreSQL
    await pool.query(
      `INSERT INTO sms_alerts (disaster_type, message, shelter_info, sent_to_all)
       VALUES ($1, $2, $3, TRUE)`,
      [disasterType, message, shelterInfo]
    );

    // 🟡 Simulated SMS send (future: replace this with actual SMS logic)
    console.log("📨 SMS Alert Sent:");
    console.log(`Disaster Type: ${disasterType}`);
    console.log(`Message: ${message}`);
    console.log(`Shelter Info: ${shelterInfo}`);

    /**
     * 🧠 If you want to send actual SMS messages:
     * 
     * // Example (Twilio Integration)
     * const accountSid = process.env.TWILIO_SID;
     * const authToken = process.env.TWILIO_TOKEN;
     * const client = twilio(accountSid, authToken);
     * 
     * const users = await pool.query("SELECT phone FROM users");
     * for (const user of users.rows) {
     *   await client.messages.create({
     *     body: `⚠️ ALERT: ${message}\n🏠 Shelter: ${shelterInfo || "N/A"}`,
     *     from: "+1234567890", // your Twilio number
     *     to: `+91${user.phone}`, // user's phone number
     *   });
     * }
     */

    // ✅ Send JSON response to Flutter app
    res.status(201).json({
      success: true,
      message: "✅ SMS alert recorded successfully (simulated send).",
    });
  } catch (error) {
    console.error("❌ Error sending SMS alert:", error);
    res.status(500).json({
      success: false,
      message: "Internal Server Error while sending SMS alert.",
    });
  }
});

/**
 * GET /api/sms/history
 * Returns all SMS alerts (for admin view)
 */
router.get("/history", async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM sms_alerts ORDER BY timestamp DESC"
    );
    res.status(200).json(result.rows);
  } catch (error) {
    console.error("❌ Error fetching SMS history:", error);
    res
      .status(500)
      .json({ success: false, message: "Error retrieving SMS history" });
  }
});

export default router;
