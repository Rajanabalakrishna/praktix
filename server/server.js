require("dotenv").config();

const express  = require("express");
const cors     = require("cors");
const mongoose = require("mongoose");
const bcrypt   = require("bcryptjs");
const jwt      = require("jsonwebtoken");

const app = express();
app.use(cors({ origin: "*" }));
app.use(express.json());

// ═══════════════════════════════════════
// SCHEMAS
// ═══════════════════════════════════════

const User = mongoose.model("User", new mongoose.Schema(
  {
    name:     { type: String, required: true, trim: true },
    email:    { type: String, required: true, unique: true, lowercase: true },
    password: { type: String, required: true },
    userType: { type: String, enum: ["learner","professional","expert"], default: "learner" },
  },
  { timestamps: true }
));

const Application = mongoose.model("Application", new mongoose.Schema(
  {
    userId:       { type: String, default: "guest" },
    programId:    { type: String, default: "general" },
    programTitle: { type: String, default: "General" },
    name:         { type: String, required: true },
    email:        { type: String, required: true },
    phone:        { type: String, required: true },
    status: { type: String, enum: ["pending","reviewing","accepted","rejected"], default: "pending" },
  },
  { timestamps: true }
));

// ═══════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════

const signToken = (id) =>
  jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN });

const ok  = (res, data, msg = "Success", code = 200) =>
  res.status(code).json({ success: true, message: msg, data });

const err = (res, msg, code = 400) =>
  res.status(code).json({ success: false, message: msg });

// ═══════════════════════════════════════
// ROUTES
// ═══════════════════════════════════════

app.get("/health", (_, res) => ok(res, null, "Only Experts API ✅"));

// ── Auth: Register ────────────────────────────────────────────────────────────
// ── Auth: Register ────────────────────────────────────────────────────────────
// ── Auth: Register ────────────────────────────────────────────────────────────
app.post("/api/auth/register", async (req, res) => {
  try {
    const { name, email, password, userType } = req.body;

    if (await User.findOne({ email }))
      return err(res, "Email already registered", 409);

    const hashed = password
      ? await bcrypt.hash(password, 12)
      : await bcrypt.hash("default123", 12); // fallback so bcrypt never gets undefined

    const user = await User.create({
      name:     name     || "Guest",
      email:    email    || `guest_${Date.now()}@praktix.com`,
      password: hashed,
      userType: userType || "learner",
    });

    ok(res,
      {
        _id:      user._id,
        name:     user.name,
        email:    user.email,
        userType: user.userType,
        token:    signToken(user._id),
      },
      "Registration successful",
      201
    );
  } catch (e) { err(res, e.message, 500); }
});

// ── Auth: Login ───────────────────────────────────────────────────────────────
app.post("/api/auth/login", async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return err(res, "Email and password required");
    const user = await User.findOne({ email });
    if (!user || !(await bcrypt.compare(password, user.password)))
      return err(res, "Invalid email or password", 401);
    ok(res, { _id: user._id, name: user.name, email: user.email, userType: user.userType, token: signToken(user._id) }, "Login successful");
  } catch (e) { err(res, e.message, 500); }
});

// ── Applications: Simple submit (no auth, no restrictions) ────────────────────
// Flutter datasource calls POST /api/applications/submit
// Accepts: name, email, phone, programTitle — all optional except name/email/phone
app.post("/api/applications/submit", async (req, res) => {
  try {
    const { name, email, phone, programTitle } = req.body;

    if (!name || !email || !phone)
      return err(res, "All fields are required");

    const appl = await Application.create({
      name,
      email,
      phone,
      programTitle: programTitle || "General",
      userId:    "guest",
      programId: "general",
    });

    ok(res, appl, `Application submitted for ${appl.programTitle}!`, 201);
  } catch (e) { err(res, e.message, 500); }
});

// ── Applications: Full submit (with userId + programId) ───────────────────────
app.post("/api/applications", async (req, res) => {
  try {
    const { userId, programId, programTitle, name, email, phone } = req.body;
    if (!name || !email || !phone)
      return err(res, "All fields are required");
    if (await Application.findOne({ userId, programId }))
      return err(res, "Already applied for this program", 409);
    const appl = await Application.create({ userId, programId, programTitle, name, email, phone });
    ok(res, appl, `Application submitted for ${programTitle}!`, 201);
  } catch (e) { err(res, e.message, 500); }
});

// ── Applications: Get by user ─────────────────────────────────────────────────
app.get("/api/applications/user/:userId", async (req, res) => {
  try {
    const apps = await Application.find({ userId: req.params.userId }).sort({ createdAt: -1 });
    ok(res, apps, "Fetched");
  } catch (e) { err(res, e.message, 500); }
});

app.use((_, res) => err(res, "Route not found", 404));

// ═══════════════════════════════════════
// START
// ═══════════════════════════════════════

mongoose.connect(process.env.MONGODB_URI).then(() => {
  console.log("✅ MongoDB connected");
  app.listen(process.env.PORT || 3000, () =>
    console.log(`🚀 Server → http://localhost:${process.env.PORT || 3000}`)
  );
}).catch((e) => { console.error("❌", e.message); process.exit(1); });