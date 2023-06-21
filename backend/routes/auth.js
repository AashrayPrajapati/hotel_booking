const express = require("express");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const router = express.Router();
const nodemailer = require("nodemailer");
// const cookieParser = require("cookie-parser");
// db mai roles halne ani tyo return garni

const Admin = require("../models/Admin");
const User = require("../models/User");

//send email to the user

var generateOtp = "";
var userEmail = "";

router.post("/forgotpassword", async (req, res) => {
  try {
    console.log("sdfsdsafasd", req.body);

    userEmail = req.body.email;
    console.log(userEmail);
    //generate 4 digit random number
    generateOtp = Math.floor(100000 + Math.random() * 900000);
    console.log(generateOtp);
    res.json({ generateOtp: generateOtp });

    let transporter = nodemailer.createTransport({
      service: "gmail", // true for 465, false for other ports
      auth: {
        user: "aashray333@gmail.com", // generated ethereal user
        pass: "dkmpizdbukjiursc", // generated ethereal password
      },
    });

    // send mail with defined transport object
    let message = {
      from: "aashray333@gmail.com", // sender address
      to: `${userEmail}`, // list of receivers
      subject: "OTP", // Subject line
      html: `
                <div style="background-color: #f4f4f4; padding: 20px;">
                    <h2 style="color: #333;">Hello, </h2>
                    
                     <div style="background-color: #fff; padding: 20px; margin-bottom: 20px;">
                     <h4 style="color: #333 ;">Your Verification OTP: ${generateOtp}</h4>
                    </div>
                    <p style="color: #777;">Thank you for using our service!</p>
                 </div>
            `,
    };
    await transporter.sendMail(message).then(() => {
      return res.status(200).send("Mail Sent");
    });
  } catch (err) {
    console.log(err);
    // return res.send(err.message);
  }
});

//verify otp
router.post("/verify-otp", async (req, res) => {
  try {
    console.log(req.body);
    const otp = req.body.otp;

    console.log(otp);
    console.log("ge", generateOtp);
    if (otp == generateOtp) {
      // console.log("SUIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
      return res.status(200).send("OTP verified");
    } else {
      return res.status(401).send("Invalid OTP");
    }
  } catch (err) {
    console.log(err);
    return res.status(401).send("Invalid OTP");
  }
});

router.patch("/reset-password", async (req, res) => {
  console.log("reset password");
  try {
    let model;
    let selectedRole;

    // const email = req.body.email;
    const { password, role } = req.body; // destructuring the email from req.body

    if (role === "User") {
      model = User;
      selectedRole = "User";
    } else if (role === "Hotel Owner") {
      model = Admin;
      selectedRole = "Hotel Owner";
    } else {
      return res.status(401).send("Invalid Email");
    }
    console.log(model);

    //checking if email exists
    console.log(req.body.email);
    const user = await model.findOne({ email: userEmail });
    console.log(user);

    //cehcking if password and confirm password matches

    console.log(password);
    //hashing the password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);
    console.log(hashedPassword);

    //updating the password
    const resetPass = await model.updateOne(
      { email: userEmail },
      {
        $set: {
          password: hashedPassword,
        },
      }
    );
    email = "";
    console.log(resetPass);
    // res.send(updateRecepPass);
    res.status(200).send("Password updated successfully");
  } catch (err) {
    console.log(err);
  }
});

module.exports = router;
