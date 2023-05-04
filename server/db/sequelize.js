const { Sequelize } = require("sequelize");

const { dbConfig } = require("./config");

let sequelize;

if (!sequelize) {
  sequelize = new Sequelize(
    dbConfig.database,
    dbConfig.username,
    dbConfig.password,
    {
      host: dbConfig.host,
      port: dbConfig.port,
      dialect: dbConfig.dialect,
      storage: dbConfig.storage,
    }
  );
}

exports.sequelize = sequelize;
