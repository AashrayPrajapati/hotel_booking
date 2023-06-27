const admin = require("firebase-admin");
const { Storage } = require("@google-cloud/storage");

// Initialize the Firebase Admin SDK with your service account credentials
const serviceAccount = require("./config/serviceAccountKey.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "your-firebase-storage-bucket-url",
});

// Create a storage instance
const storage = new Storage();

module.exports = {
  storage,
};
