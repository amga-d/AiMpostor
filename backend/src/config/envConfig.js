import dotenv from "dotenv";


dotenv.config();
const PORT = process.env.PORT || 3000;
const GEMINI_API_KEY = process.env.GEMINI_API_KEY;

export { PORT, GEMINI_API_KEY };
