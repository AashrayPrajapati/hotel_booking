const express = require("express");
const router = express.Router();
const Admin = require("../models/Admin");
const multer = require("multer");
const HotelRoom = require("../models/HotelRoom");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

router.post("/register", async (req, res) => {
  // const {error} = listValidation(req.body);
  // if (error) return res.send(error.details[0].message);

  const admin = new Admin({
    ownerName: req.body.ownerName,
    email: req.body.email,
    password: req.body.password,
    propertyName: req.body.propertyName,
    country: req.body.country,
    city: req.body.city,
    postalCode: req.body.postalCode,
    streetName: req.body.streetName,
    description: req.body.description,
  });

  try {
    const savedHotel = await admin.save();
    res.send(savedHotel);
    console.log(savedHotel);
  } catch (error) {
    res.json(error.message);
  }
});

router.post("/login", async (req, res) => {
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(req.body.password, salt);

  // const {error } = LoginValidation(req.body); // Validate the request body
  // if (error) return res.status(400).send(error.details[0].message); // If there is an error, send the first error detail as a response

  // check if email exists
  console.log("Checking user database");
  const user = await Admin.findOne({ email: req.body.email });
  if (!user) return res.send("Email is wrong");
  // res.send(user.password);

  console.log(req.body.password);
  console.log(user.password);

  // check if the password is correct
  if (req.body.password == user.password) {
    // const validPwd = await bcrypt.compare(req.body.password, user.password);
    // if (!validPwd) return res.send("Email or password is wrong");

    // create and assign a token
    const token = jwt.sign({ _id: user._id }, "whatsup");
    // const token = null;

    if (token) {
      return res.status(200).json({
        token: token,
        message: "Login successful",
      });
    } else {
      return res.json({
        status: "Error",
        message: "Invalid credentials",
      });
    }
  } else {
    return res.json({
      status: "Error",
      message: "Invalid credentials",
    });
  }
});

const upload = multer({ dest: "uploads/" });

router.post("/uploadImage", upload.single("image"), (req, res) => {
  try {
    console.log(req.file);
    // Save the file to MongoDB or any other storage service
    res.status(200).json({ message: "Image uploaded successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Failed to upload image" });
  }
});

// HOTELS...

// get all hotels
router.get("/getHotels", async (req, res) => {
  try {
    // res.json(await Admin.find());
    const Hotels = await Admin.find();
    res.json(Hotels);
  } catch (error) {
    res.json(error);
  }
});

// SEARCH HOTELS...

// search hotel by id
router.get("/getHotel/:id", async (req, res) => {
  try {
    const admin = await Admin.findById({ _id: req.params.id });
    res.json(admin);
  } catch (err) {
    res.json("ERROR");
  }
});




// get all hotels or search hotel by city or property name
router.post("/search", async (req, res) => {
  try {
    console.log('ksjdhfksahfdsakfhsakjdfh')
    const { propertyName, city } = req.body;

    if (propertyName) {
      const regex = new RegExp(req.body.propertyName, "i");
      const hotels = await Admin.find({ propertyName: regex });

      return res.json(hotels);
    } else if (city) {
      const regex = new RegExp(req.body.city, "i");
      const hotels = await Admin.find({ city: regex });
      // const hotels = await Admin.find({ city: city });
      return res.json(hotels);
    } else {
      const hotels = await Admin.find();
      console.log(hotels);
      return res.json(hotels);
    }
  } catch (error) {
    res.json(error);
  }
});

// search hotel by city
router.get("/search/city/:city", async (req, res) => {
  try {
    const regex = new RegExp(req.params.city, "i");
    const admin = await Admin.find({ 'city': regex });
    console.log(admin)
    res.json(admin);
  } catch (error) {
    res.json(error);
  }
});

// search hotel by property name
router.get("/search/name/:propertyName", async (req, res) => {
  try {
    const regex = new RegExp(req.params.propertyName, "i");
    const admin = await Admin.find({
      'propertyName': regex
    });
    res.json(admin);
  } catch (error) {
    res.json(error);
  }
});

// search hotel
// router.get('/search', async(req, res) => {
//   const { query } = req;
//   const { propertyName, city } = query;

//   try{
//     let adminQuery = {};

//     if (propertyName && city) {
//       adminQuery = { propertyName, city };
//     } else if (propertyName) {
//       adminQuery = { propertyName };
//     } else if (city) {
//       adminQuery = { city };
//     } else {
//       return res.status(400).json({ message: 'Invalid search query' });
//     }

//     const admin = await Admin.find(adminQuery);
//     res.json(admin);
//   }
//   catch(error) {
//     res.status(500).json({ message: 'Internal server error' });
//   }
// });

// update hotel by id
router.patch("/getHotel/:id", async (req, res) => {
  try {
    const updated = await Admin.updateMany(
      { _id: req.params.id },
      {
        $set: {
          ownerName: req.body.ownerName,
          email: req.body.email,
          password: req.body.password,
          propertyName: req.body.propertyName,
          country: req.body.country,
          city: req.body.city,
          postalCode: req.body.postalCode,
          streetName: req.body.streetName,
          description: req.body.description,
        },
      }
    );
    res.json(updated);
  } catch (err) {
    res.json("ERROR");
  }
});

// delete hotel by id
router.delete("/deleteHotel/:id", async (req, res) => {
  try {
    const deleted = await Admin.deleteOne({ _id: req.params.id }); //Delete the admin
    //  with the specified id
    res.json(deleted); //Send the result as a JSON object in the response
  } catch (err) {
    res.json("ERROR");
  }
});

// ROOMS...
router.get("/rooms/:id", async (req, res) => {
  try {
    const getRooms = await HotelRoom.find({ hotelId: req.params.id });
    res.json(getRooms);
  } catch (e) {
    res.json(e);
  }
});

router.delete("/rooms/:id", async (req, res) => {
  try {
    const deleted = await Admin.deleteOne({ _id: req.params.id }); //Delete the admin
    //  with the specified id
    res.json(deleted); //Send the result as a JSON object in the response
  } catch (err) {
    res.json("ERROR");
  }
});

router.patch("/updatePassword/:id", async (req, res) => {
  console.log("applebottom jeans boots with the fur");
  try {
    console.log(req.params.id);
    console.log(req.body);
    const hotel = await Admin.findById({ _id: req.params.id });

    console.log(hotel);
    // console.log(req.body);

    // if false
    if (hotel.password !== req.body.password) {
      console.log("old pasword doesnt match");
      return res.json("Old password doesn't match");
    }

    //if true
    const updated = await Admin.updateMany(
      { _id: req.params.id },
      {
        $set: {
          password: req.body.newPassword,
        },
      }
    );
    console.log("success", updated);
    res.json("Password changed successfully");
  } catch (err) {
    res.json(err);
  }
});

module.exports = router;
