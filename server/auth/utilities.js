const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");

dotenv.config();

function getJwtTokenResponse(payload) {
  console.log("IN GET AUTH TOKEN");

  if (!payload) {
    return null;
  }

  if (process.env.NODE_ENV !== "production") {
    console.log(payload);
  }

  console.log("SECRET: ", process.env.TOKEN_SECRET);

  return {
    token: jwt.sign(payload, process.env.TOKEN_SECRET, {
      expiresIn: `${process.env.JWT_LIFETIME_SECS || 3600}s`,
    }),
  };
}

module.exports = {
  getJwtTokenResponse,
};
