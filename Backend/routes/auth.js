import express from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import pool from "../db.js";
import dotenv from "dotenv";

dotenv.config();
const router = express.Router();

// ============================
// SIGNUP
// ============================
router.post("/signup", async (req, res) => {
  const { name, age, phone, email, password, location, region, emergency_contact, role } = req.body;

  if (!name || !email || !password || !region) {
    return res.status(400).json({ success: false, message: "All required fields must be filled" });
  }

  try {
    const existing = await pool.query("SELECT * FROM users WHERE email = $1", [email]);
    if (existing.rows.length > 0)
      return res.status(400).json({ success: false, message: "Email already registered" });

    const hashedPassword = await bcrypt.hash(password, 10);
    const result = await pool.query(
      `INSERT INTO users (name, age, phone, email, password, location, region, emergency_contact, role)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)
       RETURNING id, name, email, region, role`,
      [name, age, phone, email, hashedPassword, location, region, emergency_contact, role]
    );

    res.status(201).json({ success: true, user: result.rows[0], message: "User registered successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Server error" });
  }
});

// ============================
// LOGIN
// ============================
router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password)
    return res.status(400).json({ success: false, message: "Missing credentials" });

  try {
    const userResult = await pool.query("SELECT * FROM users WHERE email = $1", [email]);
    if (userResult.rows.length === 0)
      return res.status(400).json({ success: false, message: "User not found" });

    const user = userResult.rows[0];
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch)
      return res.status(401).json({ success: false, message: "Invalid password" });

    const token = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, {
      expiresIn: "1d",
    });

    res.status(200).json({
      success: true,
      message: "Login successful",
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        region: user.region,
        role: user.role,
      },
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Server error" });
  }
});

export default router;
