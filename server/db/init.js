const { sequelize } = require("./sequelize");
const { initModels } = require("../models/init_models");
const { User } = require("../models");

async function initialiseDatabaseConnection() {
  try {
    await sequelize.authenticate();

    console.log("Connection has been established successfully.");
  } catch (error) {
    console.error("Unable to connect to the database:", error);
  }

  try {
    await initModels();
    await sequelize.sync({ alter: true });

    // await User.create({
    //   first_name: "test",
    //   email: "sahej34@example.com",
    //   password: "testpass123",
    //   phone: "8360472296",
    // });

    // await User.update(
    //   {
    //     is_super_user: true,
    //   },
    //   { where: { email: "sahej341@example.com" } }
    // );

    console.log("Successfully synced to the database");
  } catch (error) {
    console.error("Unable to sync to the database:", error);
  }
}

exports.initialiseDatabaseConnection = initialiseDatabaseConnection;
exports.sequelize = sequelize;
