const express = require("express");
const router = express.Router();
const Users = require("../models/User"); //Import User Schema
const Admin = require("../models/Admin"); //Import Admin Schema
const HotelRoom = require("../models/HotelRoom"); //Import HotelRoom Schema
const Booking = require("../models/Booking"); //Import Booking Schema
require("dotenv/config");

("use strict");
const nodemailer = require("nodemailer");
const User = require("../models/User");

// async..await is not allowed in global scope, must use a wrapper
async function mail(t_price, checkInDate, checkOutDate) {
  // Generate test SMTP service account from ethereal.email
  // Only needed if you don't have a real mail account for testing
  let testAccount = await nodemailer.createTestAccount();

  // create reusable transporter object using the default SMTP transport
  let transporter = nodemailer.createTransport({
    service: "gmail", // true for 465, false for other ports
    auth: {
      user: "aashray333@gmail.com", // generated ethereal user
      pass: "dkmpizdbukjiursc", // generated ethereal password
    },
  });

  console.log(t_price);

  // send mail with defined transport object
  let info = await transporter.sendMail({
    from: "aashray333@gmail.com", // sender address
    to: "aashray333@gmail.com", // list of receivers
    subject: "Room Booking Notification", // Subject line
    text: "Hello, your hotel room has been booked.", // plain text body
    html: `
    <html>
    <head>
      <style>
        .main {
          font-family: Arial, sans-serif;
          background-color: #f5f5f5;
          color: #333;
          padding: 20px;
        }
        .container {
          max-width: 600px;
          margin: 0 auto;
          background-color: #fff;
          border: 1px solid #f5f5f5;
          border-radius: 10px;
          padding: 20px;
          box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .title {
          font-size: 24px;
          font-weight: bold;
          margin-bottom: 10px;
          color: #333;
        }
        .message {
          font-size: 16px;
          line-height: 1.5;
          margin-bottom: 20px;
        }
        .footer {
          font-size: 14px;
          color: #777;
        }
      </style>
    </head>
    <body>
      <div class="main">
       <div class="container">
        <div class="title">Room Booking Notification</div>
        <div class="message">
          Hello,<br><br>
          Your hotel room has been booked.<br><br>
          total price is: ${t_price}<br><br>
          for <br><br>
          
          Check-in Date: ${checkInDate}<br><br>
          
          Check-out Date: ${checkOutDate}<br><br>
          Thank you.
        </div>
        <div class="footer">This is an automated email. Please do not reply.</div>
        </div>
      </div>
    </body>
  </html>


`,
  });

  console.log("Message sent: %s", info.messageId);
  // Message sent: <b658f8ca-6296-ccf4-8306-87d57a0b4321@example.com>

  // Preview only available when sending through an Ethereal account
  console.log("Preview URL: %s", nodemailer.getTestMessageUrl(info));
  // Preview URL: https://ethereal.email/message/WaQKMgKddxQDoou...
}

// POST a new user
router.post("/book", async (req, res) => {
  try {
    console.log("req.bodysdfgsdgsdfg");
    console.log("req.body", req.body);
    const UserExists = await Users.findById(req.body.user);
    // console.log("USER", UserExists);
    if (!UserExists) return res.status(409).send("User does not exist");

    const HotelExists = await Admin.findById(req.body.hotel);
    // console.log("Hotel", HotelExists);
    if (!HotelExists) return res.status(409).send("Hotel does not exist");

    const HotelRoomExists = await HotelRoom.findOne({
      _id: req.body.room,
      hotelId: req.body.hotel,
    });

    console.log("HotelRoomExists");
    if (!HotelRoomExists) {
      console.log("HotelRoomExists", HotelRoomExists);
      return res
        .status(409)
        .send("Hotel room does not exist in the specified hotel");
    }
    const type = HotelRoomExists.roomType;
    console.log("typeskjdfskdfk");
    console.log("type", type);

    // Check if the room is already booked during the selected dates
    const existingBooking = await Booking.findOne({
      room: req.body.room,
      checkInDate: { $lte: req.body.checkOutDate },
      checkOutDate: { $gte: req.body.checkInDate },
    });

    if (existingBooking) {
      console.log("existing booking");
      return res
        .status(409)
        .send("The room is already booked during the selected dates");
    }

    let t_price = req.body.totalPrice;
    let checkInDate = new Date(req.body.checkInDate);
    let checkOutDate = new Date(req.body.checkOutDate);
    console.log("qwertyuiopsdfghjkxcvbnm,");
    // Create a new instance of User Schema
    const booking = new Booking({
      user: req.body.user,
      hotel: req.body.hotel,
      room: req.body.room,
      roomType: type,
      checkInDate: req.body.checkInDate,
      checkOutDate: req.body.checkOutDate,
      guests: req.body.guests,
      totalPrice: req.body.totalPrice,
      paymentStatus: req.body.paymentStatus,
    });

    console.log("from booking", booking);
    // Save the user to the database
    const createBooking = await booking.save();

    await mail(t_price, checkInDate, checkOutDate);

    return res.status(200).json({
      status: "Success",
      message: "Booking registered successfully",
      data: createBooking,
    });
  } catch (err) {
    res.status(400).json(err);
  }
});

//get all bookings with hotel id
router.get("/getBookings/:id", async (req, res) => {
  try {
    const bookings = await Booking.find({ hotel: req.params.id });
    res.json(bookings);
  } catch (error) {
    res.json(error);
  }
});

//get all bookings with user id
router.get("/getBookingsByUser/:id", async (req, res) => {
  try {
    const bookings = await Booking.find({ user: req.params.id });
    res.json(bookings);
  } catch (error) {
    res.json(error);
  }
});

//get all bookings with hotel id
router.get("/getBookingsByHotel/:id", async (req, res) => {
  try {
    const bookings = await Booking.find({ hotel: req.params.id });
    res.json(bookings);
  } catch (error) {
    res.json(error);
  }
});

module.exports = router;
