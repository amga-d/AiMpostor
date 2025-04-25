import multer from "multer";
// Configure multer for image uploads
const storage = multer.memoryStorage(); // Store image in memory
const upload = multer({ storage: storage });
export default upload;
