const Joi = require("@hapi/joi");

const regValidation = (x) => {
  const JoiSchema = Joi.object({
    firstName: Joi.string().required(),
    lastName: Joi.string().required(),
    email: Joi.string().email().required(),
    password: Joi.string().required(),
  });
  return JoiSchema.validate(x);
};

module.exports.regValidation = regValidation;
