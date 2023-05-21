const { DataTypes, Sequelize } = require("sequelize");

const { CustomModel } = require("./CustomModel");
const { sequelize } = require("../db/sequelize");

class Activity extends CustomModel {
  static init() {
    return super.init(
      {
        id: {
          type: DataTypes.UUIDV4,
          defaultValue: Sequelize.UUIDV4,
          allowNull: false,
          primaryKey: true,
        },
        label: {
          type: DataTypes.TEXT,
          allowNull: false,
        },
        color: {
          type: DataTypes.BIGINT,
          allowNull: true,
        },
        user_id: {
          type: DataTypes.UUIDV4,
          allowNull: true,
          references: {
            model: "Users",
            key: "id",
          },
        },
        icon_id: {
          type: DataTypes.UUIDV4,
          allowNull: false,
          references: {
            model: "Icons",
            key: "id",
          },
        },
      },
      { sequelize }
    );
  }
}

exports.Activity = Activity;
