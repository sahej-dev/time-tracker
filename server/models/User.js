const { DataTypes, Sequelize } = require("sequelize");

const { CustomModel } = require("./CustomModel");
const { sequelize } = require("../db/sequelize");

class User extends CustomModel {
  static init() {
    return super.init(
      {
        id: {
          type: DataTypes.UUIDV4,
          defaultValue: Sequelize.UUIDV4,
          allowNull: false,
          primaryKey: true,
        },
        username: {
          type: DataTypes.TEXT,
          allowNull: true,
          unique: true,
        },
        first_name: {
          type: DataTypes.TEXT,
          allowNull: false,
        },
        last_name: {
          type: DataTypes.TEXT,
        },
        email: {
          type: DataTypes.TEXT,
          allowNull: false,
          unique: true,
          validate: {
            isEmail: true,
          },
        },
        password: {
          type: DataTypes.TEXT,
          allowNull: false,
        },
        phone: {
          type: DataTypes.TEXT,
          unique: true,
          validate: {
            isMobilePhone: true,
          },
        },
        is_super_user: {
          type: DataTypes.BOOLEAN,
          default: null,
        },
      },
      { sequelize }
    );
  }
}

exports.User = User;
