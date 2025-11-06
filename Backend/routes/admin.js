import express from "express";
import pool from "../db.js";
import { verifyToken } from "../middleware/authMiddleware.js";

const router = express.Router();

// 🧩 Middleware to ensure admin access
const verifyAdmin = (req, res, next) => {
  if (req.user.role !== "admin") {
    return res.status(403).json({ success: false, message: "Access denied" });
  }
  next();
};

// ✅ GET all users
router.get("/users", verifyToken, verifyAdmin, async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT id, name, email, phone, region, role, created_at FROM users ORDER BY id ASC"
    );
    res.status(200).json({ success: true, users: result.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Server error" });
  }
});

// ✅ DELETE a user by ID
router.delete("/user/:id", verifyToken, verifyAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    await pool.query("DELETE FROM users WHERE id = $1", [id]);
    res.status(200).json({ success: true, message: "User deleted successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Server error" });
  }
});

export default router;
