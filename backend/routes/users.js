const express = require("express");
const router = express.Router();
const Users = require("../models/User"); //Import User Schema
const { regValidation } = require("../validate"); // Import validation function

// var fileId = mongoose.Types.ObjectId();

// GET all users
router.get("/", async (req, res) => {
  const user = await Users.find(); // Retrieve all users from the database
  res.json(user); // Send the retrieved users at a JSON object in the response
});

// POST a new user
router.post("/", async (req, res) => {
  // Validate the request body
  const { error } = regValidation(req.body);
  // if there is error, send the first error detail as a response
  if (error) return res.send(error.details[0]);

  // Create a new instance of User Schema
  const user = new Users({
    //user is the new instance of User Schema
    name: {
      firstName: req.body.firstName,
      lastName: req.body.lastName,
    },
    email: req.body.email,
    password: req.body.password,
  });

  try {
    // const userSave = await user.save();
    // res.json(userSave);
    res.json(await user.save()); // Save the user to the database and send the
    // saved user as a JSON object in the response
  } catch (err) {
    res.json(err); //If there is an error, send the error object as a
    // JSON object in the response
  }
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
          password: req.body.password
        },
      }
    );
    res.json(updated);
  } catch (err) {
    res.json("ERROR");
  }
});

module.exports = router;
