const mongoose = require("mongoose");

const HotelRoom = mongoose.Schema({
    hotelId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Admin",
        required: true,
    },
    number: {
        type: String,
        required: true,
        unique: true
    },
    capacity: {
        type: Number,
        required: true
    },
    // tala ko print garda pugxa!!!
    type: {
        type: String,
        required: true
    },
    price: {
        type: Number,
        required: true
    },
    isAvailable: {
        type: Boolean,
        required: true,
        default: true
    },
});

module.exports = mongoose.model("HotelRoom", HotelRoom);
