const express = require("express");
const bodyParser = require("body-parser");
const admin = require("firebase-admin");

const serviceAccount = require("C:\\Users\\Davie\\Programming\\FlutterDevelopment\\CapstoneProject\\flood_monitoring\\assets\\serviceAccount.json"); 

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();
const app = express();
app.use(bodyParser.json());

app.post("/water-level", async (req, res) => {
  try {
    const { level, status, timestamp } = req.body;

    await db.collection("WATER_LEVEL").add({
      level: level,
      status: status,
      timestamp: timestamp || new Date().toISOString()
    });

    console.log("Data saved:", req.body);
    res.status(200).send("Data stored in Firestore");
  } catch (err) {
    console.error("Error:", err);
    res.status(500).send("Error storing data");
  }
});

const PORT = 3000;
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on http://0.0.0.0:${PORT}`);
});
