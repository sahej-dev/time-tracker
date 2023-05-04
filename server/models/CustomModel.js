const { Model } = require("sequelize");

class CustomModel extends Model {
  static isDeletedFieldPresentInModel;

  static init(attributes, options) {
    if (!options) options = {};
    if (!options.timestamps) options.timestamps = true;
    if (!options.paranoid) options.paranoid = true;

    super.init(attributes, options);
  }
}

exports.CustomModel = CustomModel;
