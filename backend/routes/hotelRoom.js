const express = require("express");
const router = express.Router();
const Admin = require("../models/Admin");
const HotelRoom = require("../models/HotelRoom");

router.post('/register', async(req,res) => {
    // const {error} = listValidation(req.body);
    // if (error) return res.send(error.details[0].message);

    const admin = await Admin.findById(req.body.hotelId);
    if(!admin) {
        return res.status(404).json({message:"Admin not found"});
    }

    const hotelRoom = new HotelRoom({
        hotelId: req.body.hotelId,
        number: req.body.number,
        type: req.body.type,
        capacity: req.body.capacity,
        price: req.body.price,
        isAvailable: req.body.isAvailable,
    });

    try {
        res.json(await hotelRoom.save());
    } catch (error) {
        res.json(error);
    }
});

// router.get('getRooms', async(req, res) => {
//     const 
// });

module.exports = router;