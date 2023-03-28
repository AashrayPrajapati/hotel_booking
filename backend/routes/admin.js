const express = require("express");
const router = express.Router();
const Admin = require("../models/Admin");
// const bcrypt = require("bcryptjs");

router.post('/', async(req,res) => {
    // const {error} = listValidation(req.body);
    // if (error) return res.send(error.details[0].message);

    const admin = new Admin({
        ownerName: req.body.ownerName,
        email: req.body.email,
        password: req.body.password,
        propertyName: req.body.propertyName,
        country: req.body.country,
        city: req.body.city,
        postalCode: req.body.postalCode,
        streetName: req.body.streetName,
    });

    try {
        res.json(await admin.save());
    } catch (error) {
        res.json(error);
    }
});

module.exports = router;