const { DataTypes, Sequelize } = require("sequelize");

const { CustomModel } = require("./CustomModel");
const { sequelize } = require("../db/sequelize");
const { IconMetadata } = require("./IconMetada");

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

  static async upsertIcon(codepoint, fontFamily, fontPackage) {
    const icons = await Icon.findAll({
      where: { codepoint: codepoint },
      include: IconMetadata,
    });

    let iconInstance;
    for (let i = 0; i < icons?.length; i++) {
      if (
        iconInstance.dataValues.metadata.font_family === fontFamily ||
        iconInstance.dataValues.metadata.font_package === fontPackage
      ) {
        iconInstance = icons[i];
        break;
      }
    }

    if (!iconInstance) {
      let iconMetadata = await IconMetadata.findOne({
        where: {
          font_family: fontFamily,
          font_package: fontPackage,
        },
      });

      if (!iconMetadata)
        iconMetadata = await IconMetadata.create({
          where: {
            font_family: fontFamily,
            font_package: fontPackage,
          },
        });

      iconInstance = await Icon.create({
        codepoint: codepoint,
        icon_metadata_id: iconMetadata.id,
      });
    }

    return iconInstance;
  }
}

exports.Icon = Icon;
