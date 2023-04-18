const express = require("express");
const app = express();
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const cors = require('cors')
require("dotenv/config");

app.use(cors());

app.use(bodyParser.json());

const usersRoute = require('./routes/users');
const adminRoute = require("./routes/admin");
const hotelRoomRoute = require("./routes/hotelRoom");

// MIDDLEWAWRES
app.use('/users', usersRoute);
app.use('/hotel', adminRoute);
app.use('/hotelRoom', hotelRoomRoute);

app.get("/", (req, res) => {
  res.send("We are on home");
});

app.listen(3000);

mongoose.set('strictQuery', true);

mongoose.connect(
  process.env.DB_CONNECTION,
  { useNewUrlParser: true},
  () => {
    console.log("Connected to DB");
  }
);