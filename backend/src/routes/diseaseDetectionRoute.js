import { Router } from "express";
import {
  predictDisease,
  chatWithModel,
} from "../controllers/diseaseDetectionController.js";
import upload from "../config/multerConfig.js";

const router = Router();

// // Image upload endpoint
router.post("/upload", upload.single("plantImage"), predictDisease);

// Chat endpoint
router.post("/chat", chatWithModel);

export default router;
