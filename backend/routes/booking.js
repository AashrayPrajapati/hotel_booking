const express = require("express");
const router = express.Router();
const Users = require("../models/User"); //Import User Schema
const Admin = require("../models/Admin"); //Import Admin Schema
const HotelRoom = require("../models/HotelRoom"); //Import HotelRoom Schema
const Booking = require("../models/Booking"); //Import Booking Schema
require("dotenv/config");

// POST a new user
router.post("/book", async (req, res) => {
  try {
    const UserExists = await Users.findById(req.body.user);
    console.log(UserExists)
    if (!UserExists) return res.status(409).send("User does not exist");

    const HotelExists = await Admin.findById(req.body.hotel);
    if (!HotelExists) return res.status(409).send("Hotel does not exist");

    const HotelRoomExists = await HotelRoom.findOne({
      _id: req.body.room,
      hotelId: req.body.hotel,
    });

    if (!HotelRoomExists)
      return res
        .status(409)
        .send("Hotel room does not exist in the specified hotel");

    // Check if the room is already booked during the selected dates
    const existingBooking = await Booking.findOne({
      room: req.body.room,
      checkInDate: { $lte: req.body.checkOutDate },
      checkOutDate: { $gte: req.body.checkInDate },
    });

    if (existingBooking)
      return res
        .status(409)
        .send("The room is already booked during the selected dates");

    // Create a new instance of User Schema
    const booking = new Booking({
      user: req.body.user,
      hotel: req.body.hotel,
      room: req.body.room,
      checkInDate: req.body.checkInDate,
      checkOutDate: req.body.checkOutDate,
      guests: req.body.guests,
      totalPrice: req.body.totalPrice,
      paymentStatus: req.body.paymentStatus,
    });

    // Save the user to the database
    const createBooking = await booking.save();

    return res.status(200).json({
      status: "Success",
      message: "Booking registered successfully",
      data: createBooking,
    });
  } catch (err) {
    res.status(400).json(err);
  }
});

module.exports = router;
