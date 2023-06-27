const express = require("express");
const router = express.Router();
const Admin = require("../models/Admin");
const HotelRoom = require("../models/HotelRoom");
const multer = require("multer");

router.post("/register", async (req, res) => {
  // const {error} = listValidation(req.body);
  // if (error) return res.send(error.details[0].message);

  console.log(req.body);

  const admin = await Admin.findById(req.body.hotelId);
  if (!admin) {
    console.log("nono");
    return res.status(404).json({ message: "Admin not found" });
  }

  const hotelRoom = new HotelRoom({
    hotelId: req.body.hotelId,
    roomType: req.body.roomType,
    price: req.body.price,
    maxCapacity: req.body.maxCapacity,
    isAvailable: "true",
    // image: req.body.image,
  });

  try {
    
    saveHotelRoom = await hotelRoom.save()
    console.log(saveHotelRoom)
    res.json(saveHotelRoom._id);
  } catch (error) {
    res.json(error);
  }
});

// Configure Multer storage
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/"); // Specify the destination folder where the images will be saved
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname); // Use the original filename for the saved image
  },
});

// Create a Multer instance with the configured storage
const upload = multer({ storage: storage });

// Define the endpoint for image upload
router.post("/upload", upload.single("image"), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: "No image file provided" });
  }

  // Access the uploaded file information
  const file = req.file;
  console.log("Uploaded file:", file);

  // Save the relevant information to MongoDB or perform other operations

  return res.status(200).json({ message: "Image uploaded successfully" , });
});

//delete a room
router.delete("/deleteRoom/:id", async (req, res) => {
  try {
    const removedRoom = await HotelRoom.remove({ _id: req.params.id });
    res.json(removedRoom);
  } catch (error) {
    res.json(error);
  }
});

//create a patch request to update the room
router.patch("/updateRoom/:id", async (req, res) => {
  try {
    const updatedRoom = await HotelRoom.updateOne(
      { _id: req.params.id },
      {
        $set: {
          roomType: req.body.roomType,
          price: req.body.price,
          maxCapacity: req.body.maxCapacity,
          isAvailable: req.body.isAvailable,
        },
      }
    );
    res.json(updatedRoom);
  } catch (error) {
    res.json(error);
  }
});

router.get("/getRooms/:id", async (req, res) => {
  try {
    const hotelRooms = await HotelRoom.find({ hotelId: req.params.id });
    res.json(hotelRooms);
  } catch (error) {
    res.json(error);
  }
});

router.get("/getHotels/:id", async (req, res) => {
  try {
    const admin = await Admin.findById({ _id: req.params.id });
    res.json(admin);
  } catch (err) {
    res.json("ERROR");
  }
});

module.exports = router;
