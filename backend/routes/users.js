const express = require("express");
const router = express.Router();
const Users = require("../models/User"); //Import User Schema
const bcrypt = require("bcryptjs"); // Import bcryptjs for password hashing
const { regValidation } = require("../validation/validation"); // Import validation function
const jwt = require("jsonwebtoken");
require("dotenv/config");

// POST a new user
router.post("/register", async (req, res) => {
  const { error } = regValidation(req.body); // Validate the request body

  if (error) return res.status(400).send(error.details[0].message); // If there is an error, send the first error detail as a response

  // Check if email already exists
  const emailExists = await Users.findOne({ email: req.body.email });
  if (emailExists) return res.status(409).send("Email already exists");

  // Generate a salt and hash the password
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(req.body.password, salt);

  // Create a new instance of User Schema
  const user = new Users({
    name: req.body.name,
    email: req.body.email,
    password: hashedPassword,
  });

  try {
    // Save the user to the database
    const savedUser = await user.save();

    return res.status(200).json({
      status: "Success",
      message: "User registered successfully",
      data: savedUser,
    });
  } catch (err) {
    res.json("ERROR");
  }
});

// POST a login request
router.post("/login", async (req, res) => {
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(req.body.password, salt);

  // const {error } = LoginValidation(req.body); // Validate the request body
  // if (error) return res.status(400).send(error.details[0].message); // If there is an error, send the first error detail as a response

  // check if email exists
  console.log('Checking user database')
  const user = await Users.findOne({ email: req.body.email });
  if (!user) return res.send("Email or password is wrong");
  // res.send(user.password);

  const validPwd = await bcrypt.compare(req.body.password, user.password);
  if (!validPwd) return res.send("Email or password is wrong");

  // create and assign a token
  const token = jwt.sign({ _id: user._id }, "whatsup");
  // const token = null;

  if (token)

    return res.status(200).json({
      token: token,
      message: "Login successful",
    });
  else
    return res.status(400).json({
      status: "Error",
      message: "Invalid credentials",
    });
});

router.get("/", async (req, res) => {
  const user = await Users.find(); // Retrieve all users from the database
  res.json(user); // Send the retrieved users at a JSON object in the response
});

router.get("/:id", async (req, res) => {
  try {
    const user = await Users.findById({ _id: req.params.id });
    res.json(user);
  } catch (err) {
    res.json("ERROR");
  }
});

// DELETE a user by id
router.delete("/:id", async (req, res) => {
  try {
    const deleted = await Users.deleteOne({ _id: req.params.id }); //Delete the user
    //  with the specified id
    res.json(deleted); //Send the result as a JSON object in the response
  } catch (err) {
    res.json("ERROR");
  }
});

router.patch("/:id", async (req, res) => {
  try {
    const updated = await Users.updateMany(
      { _id: req.params.id },
      {
        $set: {
          name: { firstName: req.body.firstName, lastName: req.body.lastName },
          email: req.body.email,
          password: req.body.password,
        },
      }
    );
    res.json(updated);
  } catch (err) {
    res.json("ERROR");
  }
});

module.exports = router;
