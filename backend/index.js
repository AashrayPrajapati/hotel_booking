const express = require("express");
const app = express();
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const cors = require('cors')
require("dotenv/config");

app.use(cors());

app.use(bodyParser.json());

// const postsRoute = require("./routes/posts");
const usersRoute = require('./routes/users');

// MIDDLEWAWRES
// app.use("/posts", postsRoute);
app.use('/users', usersRoute);

app.get("/", (req, res) => {
  res.send("We are on home");
});

// FOR RUNNING ON SPECIFIC PORT
app.listen(3000);

mongoose.connect(
  process.env.DB_CONNECTION,
  { useNewUrlParser: true},
  () => {
    console.log("Connected to DB");
  }
);