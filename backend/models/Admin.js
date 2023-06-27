const mongoose = require("mongoose");

const AdminSchema = mongoose.Schema({
    ownerName:{
        type: String,
        required: [true, "Name is required"],
    },
    email:{
        type: String,
        required: [true, "Email is required"],
    },
    password:{
        type: String,
        required: [true, "Password is required"],
    },
    propertyName:{
        type: String,
        required: [true, "Property name is required"],
    },
    country:{
        type: String,
        required: [true, "Country is required"],
    },
    city:{
        type: String,
        required: [true, "City is required"],
    },
    postalCode:{
        type: String,
        required: [true, "Postal code is required"],
    },
    streetName:{
        type: String,
        required: [true, "Street name is required"],
    },
    description:{
        type: String,
        required: [true, "Description is required"],
    },
    
});

module.exports = mongoose.model("Admin", AdminSchema);
