const { DataTypes, Sequelize } = require("sequelize");

const { CustomModel } = require("./CustomModel");
const { sequelize } = require("../db/sequelize");

class IconMetadata extends CustomModel {
  static init() {
    return super.init(
      {
        id: {
          type: DataTypes.UUIDV4,
          defaultValue: Sequelize.UUIDV4,
          allowNull: false,
          primaryKey: true,
        },
        font_family: {
          type: DataTypes.TEXT,
          allowNull: true,
        },
        font_package: {
          type: DataTypes.TEXT,
          allowNull: true,
        },
      },
      { sequelize }
    );
  }
}

exports.IconMetadata = IconMetadata;
