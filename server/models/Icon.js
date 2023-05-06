const { DataTypes, Sequelize } = require("sequelize");

const { CustomModel } = require("./CustomModel");
const { sequelize } = require("../db/sequelize");

class Icon extends CustomModel {
  static init() {
    return super.init(
      {
        id: {
          type: DataTypes.UUIDV4,
          defaultValue: Sequelize.UUIDV4,
          allowNull: false,
          primaryKey: true,
        },
        codepoint: {
          type: DataTypes.BIGINT,
          allowNull: false,
        },
        icon_metadata_id: {
          type: DataTypes.UUIDV4,
          references: {
            model: "IconMetadata",
            key: "id",
          },
        },
      },
      { sequelize }
    );
  }
}

exports.Icon = Icon;
