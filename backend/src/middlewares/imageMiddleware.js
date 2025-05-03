import { plants } from "../config/gcStorageConfig.js";
import { MulterError } from "multer";
const saveImage = async (req, res, next) => {
  if (!req.file) {
    return res.status(400).json({ error: "No file uploaded" });
  }

  try {
    const timestamp = new Date().toISOString().replace(/[-:.TZ]/g, "");
    const filename = `${req.user.uid}_${timestamp}_${req.file.originalname}`;
    console.log("Uploading file:", filename);
    const blob = plants.file(filename);
    const blobStream = blob.createWriteStream({
      resumable: false,
      contentType: req.file.mimetype,
      predefinedAcl: "publicRead",
    });
    blobStream.on("error", (error) => {
      console.error("Error uploading file:", error);
      return res.status(500).json({ error: "Error uploading file." });
    });

    blobStream.on("finish", () => {
      const publicUrl = `https://storage.googleapis.com/${plants.name}/${blob.name}`;
      console.log("File uploaded successfully:", publicUrl);
      req.file.publicUrl = publicUrl;
      next();
    });

    blobStream.end(req.file.buffer);
  } catch (error) {
    console.error("Error uploading file:", error);
    return res.status(500).json({ error: "Error uploading file." });
  }
};

const multerErrorHandler = (err, req, res, next) => {
  if (err instanceof MulterError) {
    if (err.code === "LIMIT_FILE_SIZE") {
      return res
        .status(400)
        .json({ error: "File size is too large! Max 5MB allowed." });
    } else if (err.code === "LIMIT_UNEXPECTED_FILE") {
      return res
        .status(400)
        .json({ error: "Unexpected field! Only 'plantImage' is allowed." });
    }
    return res.status(400).json({ error: `Multer error: ${err.message}` });
  } else if (err) {
    return res.status(400).json({ error: `Error: ${err.message}` });
  }
  next();
};
export { saveImage, multerErrorHandler };
