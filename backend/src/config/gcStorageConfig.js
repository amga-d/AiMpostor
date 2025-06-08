import { Storage} from "@google-cloud/storage";
import { GC_CREDENTIAL_PATH, GC_BUCKET_NAME } from "./envConfig.js";
import fs from "fs";

// Load Google Cloud credentials from the specified path
if (!GC_CREDENTIAL_PATH) {
  throw new Error("GC_CREDENTIAL_PATH is not defined in the environment variables.");
}
// const GC_CREDENTIAL = fs.readFileSync(GC_CREDENTIAL_PATH, "utf8");
// const serviceAccount = JSON.parse(GC_CREDENTIAL);
// 
const gcStorage = new Storage({
  projectId: 112,
  credentials: GC_CREDENTIAL_PATH 
});

const plants = gcStorage.bucket(GC_BUCKET_NAME);

export { plants };
