const mongoose = require("mongoose");

const HotelRoom = mongoose.Schema({
    hotelId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Admin",
        required: true,
    },
    // tala ko print garda pugxa!!!
    roomType: {
        type: String,
        required: true
    },
    price: {
        type: Number,
        required: true
    },
    maxCapacity: {
        type: Number,
        required: true
    },
});

module.exports = mongoose.model("HotelRoom", HotelRoom);
