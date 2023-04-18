const express = require("express");
const router = express.Router();
const Admin = require("../models/Admin");
const multer = require('multer');
const HotelRoom = require("../models/HotelRoom");
// const bcrypt = require("bcryptjs");

router.post('/register', async(req,res) => {
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
        res.json(await admin.save());
    } catch (error) {
        res.json(error);
    }
});

const upload = multer({ dest: 'uploads/' });

router.post('/uploadImage', upload.single('image'), (req, res) => {
  try {
    console.log(req.file);
    // Save the file to MongoDB or any other storage service
    res.status(200).json({ message: 'Image uploaded successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to upload image' });
  }
});

router.get('/getHotels', async(req, res) => {
    try{
        res.json(await Admin.find());
    } catch(error) {
        res.json(error);
    }
});

router.get("/getHotels/:id", async (req, res) => {
    try {
      const user = await Admin.findById({ _id: req.params.id });
      res.json(user);
    } catch (err) {
      res.json("ERROR");
    }
});

router.patch("/getHotels/:id", async (req, res) => {
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

router.get('/rooms/:id', async(req, res)=>{
  try{
    const getRooms = await HotelRoom.find({hotelId:req.params.id})
    res.json(getRooms);
  } catch (e) {
    res.json(e)
  }
})

module.exports = router;