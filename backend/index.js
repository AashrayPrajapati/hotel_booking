const express = require("express");
const app = express();
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const cors = require('cors')
require("dotenv/config");

app.use(cors());

app.use(bodyParser.json());

const usersRoute = require('./routes/users');
const adminRoute = require("./routes/hotel");
const hotelRoomRoute = require("./routes/hotelRoom");
const bookingRoute = require("./routes/booking");
const commentRoute = require("./routes/comment");
const authRoute = require("./routes/auth");

// MIDDLEWAWRES
app.use('/users', usersRoute);
app.use('/hotel', adminRoute);
app.use('/hotelRoom', hotelRoomRoute);
app.use('/bookRoom', bookingRoute);
app.use('/comment', commentRoute);
app.use('/auth', require('./routes/auth'));


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