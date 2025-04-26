import express from "express";
import cors from "cors";

import { PORT } from "./src/config/envConfig.js";

import chatsRoute from "./src/routes/chatsRoute.js";
import userRoute from "./src/routes/userRoute.js";
const app = express();

// Middleware to enable CORS
app.use(cors());
// Middleware to parse JSON and URL-encoded data
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// Middleware to serve static files
app.use(express.static("public"));
// Middleware to handle file uploads
app.use("/api/v1/chats/", chatsRoute);
app.use("/api/v1/user/", userRoute);
// Middleware to handle 404 errors

// TODO: Make a middleware to handle errors
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
