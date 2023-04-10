const express = require("express");
const router = express.Router();
const Admin = require("../models/Admin");
const multer = require('multer');
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
    });

    try {
        res.json(await admin.save());
    } catch (error) {
        res.json(error);
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
          },
        }
      );
      res.json(updated);
    } catch (err) {
      res.json("ERROR");
    }
});

// Set up storage for uploaded files
const storage = multer.diskStorage({
  destination: function(req, file, cb) {
    cb(null, 'uploads/')
  },
  filename: function(req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9)
    cb(null, file.fieldname + '-' + uniqueSuffix + '.' + file.originalname.split('.').pop())
  }
});

// Set up multer middleware to handle file uploads
const upload = multer({ storage: storage });

// Define route for file upload
router.post('/upload', upload.single('file'), (req, res) => {
  // Handle uploaded file here
  console.log(req.file);
  res.send('File uploaded successfully');
});

module.exports = router;