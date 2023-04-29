const express = require("express");
const router = express.Router();
const Admin = require("../models/Admin");
const HotelRoom = require("../models/HotelRoom");

router.post('/register', async(req,res) => {
    // const {error} = listValidation(req.body);
    // if (error) return res.send(error.details[0].message);

    let hotel= "64365319012a04f615c9dcf0"

    const admin = await Admin.findById(hotel);
    if(!admin) {
        return res.status(404).json({message:"Admin not found"});
    }

    const hotelRoom = new HotelRoom({
        hotelId: hotel,
        roomType: req.body.roomType,
        price: req.body.price,
        maxCapacity: req.body.maxCapacity,
    });

    try {
        res.json(await hotelRoom.save());
    } catch (error) {
        res.json(error);
    }
});

router.get('/getRooms/:id', async(req, res) => {
    try{
        res.json(await Admin.find());
    } catch(error) {
        res.json(error);
    }
});

router.get("/getHotels/:id", async (req, res) => {
    try {
      const admin = await Admin.findById({ _id: req.params.id });
      res.json(admin);
    } catch (err) {
      res.json("ERROR");
    }
});

module.exports = router;