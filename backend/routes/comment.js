const express = require("express");
const router = express.Router();
const Users = require("../models/User"); //Import User Schema
const Admin = require("../models/Admin"); //Import Admin Schema
const Comment = require("../models/Comment");

// Create a new comment
router.post("/post", async (req, res) => {
  try {
     if (req.body) {
      console.log("user");

      const userExists = await Users.findById(req.body.user);
      console.log(userExists);
      if (!userExists) return res.status(409).send("User does not exist");

      const comment = new Comment({
        user: req.body.user,
        userName: userExists.name,
        hotelId: req.body.hotelId,
        comment: req.body.comment,
      });

      const savedComments = await comment.save();
      res.status(201).json(savedComments);
    } else {
      console.log("admin");
      const userExists = await Admin.findById(req.body.hotelId);
      if (!userExists) return res.status(409).send("Admin does not exist");
      const comment = new Comment({
        user: req.body.user,
        hotelId: req.body.hotelId,
        comment: req.body.comment,
      });

      const savedComments = await comment.save();
      res.status(201).json(savedComments);  
    }
  } catch (err) {
    res.status(500).json(err);
  }
});

// get comment of specfic hotel
router.get("/getComment/:id", async (req, res) => {
  try {
    const comments = await Comment.find({ hotelId: req.params.id });
    res.status(200).json(comments);
  } catch (err) {
    res.status(500).json(err);
  }
});

module.exports = router;
