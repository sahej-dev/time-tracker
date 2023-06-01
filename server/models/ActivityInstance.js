const { DataTypes, Sequelize } = require("sequelize");

const { CustomModel } = require("./CustomModel");
const { sequelize } = require("../db/sequelize");

class ActivityInstance extends CustomModel {
  static init() {
    return super.init(
      {
        id: {
          type: DataTypes.UUIDV4,
          defaultValue: Sequelize.UUIDV4,
          allowNull: false,
          primaryKey: true,
        },
        start_at: {
          type: DataTypes.DATE,
          allowNull: false,
        },
        end_at: {
          type: DataTypes.DATE,
          allowNull: true,
        },
        comment: {
          type: DataTypes.TEXT,
          allowNull: true,
        },
        activity_id: {
          type: DataTypes.UUIDV4,
          allowNull: false,
          references: {
            model: "Activities",
            key: "id",
          },
        },
      },
      { sequelize }
    );
  }
}

exports.ActivityInstance = ActivityInstance;
