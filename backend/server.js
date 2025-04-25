import express from "express";
import cors from "cors";

import { PORT } from "./src/config/envConfig.js";

import diseaseDetectionRoute from "./src/routes/diseaseDetectionRoute.js";

const app = express();

// Middleware to enable CORS
app.use(cors());
// Middleware to parse JSON and URL-encoded data
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// Middleware to serve static files
app.use(express.static("public"));

app.use("/api/v1/", diseaseDetectionRoute);

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
