const {
  User,
  Activity,
  Icon,
  IconMetadata,
  ActivityInstance,
} = require("./index");

async function initModels() {
  await User.init();
  await Activity.init();
  await ActivityInstance.init();
  await Icon.init();
  await IconMetadata.init();

  Activity.belongsTo(User, { foreignKey: "user_id", onDelete: "RESTRICT" });
  User.hasMany(Activity, { as: "activities", foreignKey: "user_id" });

  Activity.belongsTo(Icon, { foreignKey: "icon_id", onDelete: "RESTRICT" });
  Icon.hasMany(Activity, { as: "activities", foreignKey: "icon_id" });

  Icon.belongsTo(IconMetadata, {
    foreignKey: "icon_metadata_id",
    onDelete: "RESTRICT",
  });
  IconMetadata.hasMany(Icon, { as: "icons", foreignKey: "icon_metadata_id" });

  ActivityInstance.belongsTo(Activity, {
    foreignKey: "activity_id",
    onDelete: "RESTRICT",
  });
  Activity.hasMany(ActivityInstance, {
    as: "instances",
    foreignKey: "activity_id",
  });
}

exports.initModels = initModels;
