import { Router } from "express";
import { verifyUser } from "../middlewares/userMiddleware.js";
import {
  getChatController,
  listChatsController,
} from "../controllers/chatsController.js";
import {
  predictDisease,
  chatWithModel,
} from "../controllers/diseaseDetectionController.js";
import {
  saveImage,
  multerErrorHandler,
} from "../middlewares/imageMiddleware.js";
import upload from "../config/multerConfig.js";

const router = Router();

// Chat endpoint
// list all chats for a user
router.get("/", verifyUser, listChatsController);

// get chat by id for a user
router.get("/:chatId", verifyUser, getChatController);

// upload Image
router.post(
  "/upload",
  verifyUser,
  upload.single("plantImage"),
  multerErrorHandler,
  saveImage,
  predictDisease
);

// chat with model
router.post("/chat", verifyUser, chatWithModel);
export default router;

// TODO: check if the user exists in your database
