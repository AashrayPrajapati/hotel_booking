const mongoose = require("mongoose");

const HotelRoom = mongoose.Schema({
    hotelId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Admin",
        required: true,
    },
    roomType: {
        type: String,
        required: true
    },
    price: {
        type: String,
        required: true
    },
    maxCapacity: {
        type: String,
        required: true
    },
    isAvailable: {
        type: String,
        required: true,
        default: true
    },
});

module.exports = mongoose.model("HotelRoom", HotelRoom);
