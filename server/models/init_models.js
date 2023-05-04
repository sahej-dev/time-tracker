const { User } = require("./index");

async function initModels() {
  await User.init();
}

exports.initModels = initModels;
