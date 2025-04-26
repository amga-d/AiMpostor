import { initializeApp, cert } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { FIREBASE_SERVICE_ACCOUNT_KEY } from "./envConfig.js";

const serviceAccount = JSON.parse(FIREBASE_SERVICE_ACCOUNT_KEY);

const firebaseApp = initializeApp({
  credential: cert(serviceAccount),
});
export const db = getFirestore(firebaseApp);

// const usersCollection = db.collection("users");
// await usersCollection.get().then((snapshot) => {
//   snapshot.forEach((doc) => {
//     console.log(doc.data());
//   });
// });
