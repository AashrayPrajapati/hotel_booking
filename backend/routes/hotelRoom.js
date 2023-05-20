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

  console.log("suiiiiiii");

  const hotelRoom = new HotelRoom({
    hotelId: req.body.hotelId,
    roomType: req.body.roomType,
    price: req.body.price,
    maxCapacity: req.body.maxCapacity,
    isAvailable: "true",
  });

  try {
    res.json(await hotelRoom.save());
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
    res.json(await Admin.find());
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
