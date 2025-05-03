import { getChat, listChats } from "../models/chatModel.js";

// Get chat by ID for a user
const getChatController = async (req, res) => {
  const userId = req.user.uid;
  const chatId = req.params.chatId;
  if (!chatId) {
    return res.status(400).json({
      success: false,
      message: "Chat ID is required",
    });
  }
  try {
    const response = await getChat(userId, chatId);
    if (response.success) {
      return res.status(200).json({
        success: true,
        message: "Chat retrieved successfully",
        data: response.data,
      });
    } else {
      return res.status(200).json({
        success: false,
        message: response.message,
      });
    }
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// List all chats for a user
const listChatsController = async (req, res) => {
  const userId = req.user.uid;
  try {
    const response = await listChats(userId);
    if (response.success) {
      return res.status(200).json({
        success: true,
        message: "Chats retrieved successfully",
        data: response.data,
      });
    } else {
      return res.status(200).json({
        success: false,
        message: response.message,
      });
    }
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export { listChatsController, getChatController };
