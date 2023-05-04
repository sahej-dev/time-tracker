const fs = require("fs");

const morgan = require("morgan");

const logger = morgan("combined", {
  stream: fs.createWriteStream(`${__dirname}/default.log`, { flags: "a" }),
});

exports.logger = logger;
