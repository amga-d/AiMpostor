import {
  generateDiseasePrediction,
  generateContentResponse,
} from "../ai/diseaseDetectionAi.js";
import mime from "mime-types"; // Use mime-types library to get the MIME type

// Store chat history in-memory (for demonstration purposes only; use a database in production)
const chatHistory = {}; // TODO : Use a database for persistent storage

export const predictDisease = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: "No image uploaded." });
    }

    const conversationId =
      req.body.conversationId || Math.random().toString(36).substring(2, 15); // Generate a unique ID if not provided

    // Get previous messages from chat history
    const previousMessages = chatHistory[conversationId] || [];

    // Convert the image buffer to a base64 string
    const imageBase64 = req.file.buffer.toString("base64");
    const mimeType = mime.lookup(req.file.originalname); // Assuming it's a JPEG image; TODO: Check the actual MIME type
    // const mimeType = mime.lookup(req.file.originalname); // Use mime-types library to get the MIME type
    const imageContent = {
      mimeType: mimeType,
      data: imageBase64,
    };
    const result = await generateDiseasePrediction(
      imageContent,
      previousMessages
    );

    if (!chatHistory[conversationId]) {
      chatHistory[conversationId] = [];
    }

    // Don't store the full image in chat history as it causes issues with the Gemini API
    // Instead, store a text reference to the uploaded image
    chatHistory[conversationId].push({
      role: "user",
      parts: [
        {
          text: "I uploaded a plant image for disease analysis.",
        },
      ],
    });

    // Store model's message
    chatHistory[conversationId].push({
      role: "model",
      parts: result.error
        ? [{ text: result.error }]
        : [{ text: JSON.stringify(result) }],
    });
    console.table(chatHistory);
    res.json({ result, conversationId });
  } catch (error) {
    console.error("Upload error:", error);
    res.status(500).json({ error: "Failed to process image." });
  }
};

export const chatWithModel = async (req, res) => {
  const { conversationId, message } = req.body;

  if (!conversationId || !message) {
    return res
      .status(400)
      .json({ error: "Conversation ID and message are required." });
  }

  try {
    // Get previous messages from chat history
    const previousMessages = chatHistory[conversationId];
    if (!previousMessages) {
      return res.status(404).json({
        error: "Conversation ID not found or no previous messages.",
      });
    }
    // Clone the previousMessages to avoid modifying the original array
    const clonedMessages = [...previousMessages];

    const responseText = await generateContentResponse(clonedMessages, message);

    // Append only the new messages to the chat history
    if (!chatHistory[conversationId]) {
      chatHistory[conversationId] = [];
    }
    chatHistory[conversationId].push({
      role: "user",
      parts: [{ text: message }],
    });
    chatHistory[conversationId].push({
      role: "model",
      parts: [{ text: responseText }],
    });

    // console.log(JSON.stringify(chatHistory, null, 4));
    res.json({ response: responseText });
  } catch (error) {
    console.error("Chat error:", error);
    res.status(500).json({ error: "Failed to send message." });
  }
};
