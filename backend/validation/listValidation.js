const Joi = require("@hapi/joi");

const regValidation = (x) => {
  const JoiSchema = Joi.object({
    ownerName: Joi.string().required(),
    email: Joi.string().email().required(),
    password: Joi.string().required(),
    propertyName: Joi.string().required(),
    country: Joi.string().required(),
    city: Joi.string().required(),
    postalCode: Joi.string().required(),
    streetName: Joi.string().required(),
  });
  return JoiSchema.validate(x);
};

module.exports.regValidation = regValidation;
