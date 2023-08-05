const {
  Activity,
  Icon,
  IconMetadata,
  User,
  ActivityInstance,
} = require("../models");

const {
  isUserActivityOwnerOrSuperuser,
  deleteWithChildTablesCascade,
  restoreWithChildTablesCascade,
} = require("../utilities");

const { sequelize } = require("../db/sequelize");

module.exports = (io, socket) => {
  const readAllActivities = async (callback) => {
    const user = socket.request.user;
    console.log("IACITJIN IUSLERJL L:SDF::::", user);
    let activities;
    if (user && !user.is_super_user) {
      activities = await Activity.findAll({
        where: { user_id: user.id },
        include: {
          model: Icon,
          as: "icon",
          include: { model: IconMetadata, as: "metadata" },
        },
      });
    } else if (user.is_super_user) {
      activities = await Activity.findAll({
        include: {
          model: Icon,
          as: "icon",
          include: { model: IconMetadata, as: "metadata" },
        },
      });
    } else {
      activities = [];
    }
    // console.log(activities);

    callback(activities);
  };

  const createActivity = async (payload) => {
    const user = socket.request.user;

    if (payload.user_id && payload.user_id !== user.id && !user.is_super_user) {
      return;
    }

    const {
      id = null,
      label,
      color,
      user_id = user.id,
      icon_id,
      icon_codepoint,
      icon_family = null,
      icon_package = null,
      createdAt = null,
    } = payload;

    console.log("REVEIVEDD ID: ", id);
    let createdActivity;

    if (icon_id) {
      const icon = await Icon.findByPk(icon_id);
      if (!icon)
        return socket.to(user.id).emit("error", "invalid icon_id provided");

      createdActivity = await Activity.create({
        id,
        label,
        color,
        user_id,
        icon_id,
        createdAt,
      });
    } else if (icon_codepoint) {
      const icons = await Icon.findAll({
        where: { codepoint: icon_codepoint },
        include: { model: IconMetadata, as: "metadata" },
      });

      let icon;
      for (let i = 0; i < icons.length; i++) {
        console.log(icons[i]);
        if (
          (icons[i].dataValues.metadata.font_family === icon_family,
          icons[i].dataValues.metadata.font_package === icon_package)
        ) {
          icon = icons[i];
          break;
        }
      }

      if (!icon) {
        let metadata = await IconMetadata.findOne({
          where: { font_family: icon_family, font_package: icon_package },
        });

        if (!metadata) {
          metadata = await IconMetadata.create({
            font_family: icon_family,
            font_package: icon_package,
          });
        }

        icon = await Icon.create({
          codepoint: icon_codepoint,
          icon_metadata_id: metadata.dataValues.id,
        });
      }

      createdActivity = await Activity.create({
        id,
        label,
        color,
        user_id,
        icon_id: icon.id,
        createdAt,
      });
    } else {
      socket
        .to(user.id)
        .emit("error", "either icon_id, or icon_codepoint must be provided");
    }

    const result = await Activity.findByPk(createdActivity.id, {
      include: {
        model: Icon,
        as: "icon",
        include: { model: IconMetadata, as: "metadata" },
      },
    });

    socket.to(user.id).emit("activity:create", result);
  };

  const editActivity = async (payload) => {
    const user = socket.request.user;

    const activity = await Activity.findByPk(payload.id, {
      include: {
        model: Icon,
        as: "icon",
        include: { model: IconMetadata, as: "metadata" },
      },
    });

    if (!activity)
      return socket.to(user.id).emit("error", "invalid id provided");

    if (!isUserActivityOwnerOrSuperuser(user, activity))
      return socket.to(user.id).emit("error", "Forbidden");

    const {
      label,
      color,
      icon_id,
      icon_codepoint,
      icon_family = null,
      icon_package = null,
      updatedAt = null,
    } = payload;

    if (icon_id) {
      const icon = await Icon.findByPk(icon_id);
      if (!icon)
        return socket.to(user.id).emit("error", "invalid icon_id provided");

      await activity.update({
        label,
        color,
        icon_id,
        updatedAt,
      });
    } else if (icon_codepoint) {
      const icons = await Icon.findAll({
        where: { codepoint: icon_codepoint },
        include: { model: IconMetadata, as: "metadata" },
      });

      let icon;
      for (let i = 0; i < icons.length; i++) {
        if (
          (icons[i].dataValues.metadata.font_family === icon_family,
          icons[i].dataValues.metadata.font_package === icon_package)
        ) {
          icon = icons[i];
          break;
        }
      }

      if (!icon) {
        let metadata = await IconMetadata.findOne({
          where: { font_family: icon_family, font_package: icon_package },
        });

        if (!metadata) {
          metadata = await IconMetadata.create({
            font_family: icon_family,
            font_package: icon_package,
          });
        }

        icon = await Icon.create({
          codepoint: icon_codepoint,
          icon_metadata_id: metadata.dataValues.id,
        });
      }

      await activity.update({
        label,
        color,
        icon_id: icon.id,
        updatedAt,
      });
    } else {
      await activity.update({
        label,
        color,
        updatedAt,
      });
    }

    socket.to(user.id).emit("activity:edit", activity);
  };

  const deleteActivity = async (payload) => {
    const user = socket.request.user;

    const activity = await Activity.findByPk(payload.id);
    if (!activity)
      return socket.to(user.id).emit("error", "invalid activity id");

    if (!isUserActivityOwnerOrSuperuser(user, activity))
      return socket.to(user.id).emit("error", "Forbidden");

    await deleteWithChildTablesCascade({
      sequelize,
      table: Activity,
      childTables: [ActivityInstance],
      tablePKs: activity.id,
      tablePkAttributeName: "activity_id",
    });

    socket.to(user.id).emit("activity:delete", payload);
  };

  const restoreActivity = async (payload) => {
    const user = socket.request.user;

    const activity = await Activity.findByPk(payload.id, {
      paranoid: false,
      include: {
        model: Icon,
        as: "icon",
        include: { model: IconMetadata, as: "metadata" },
      },
    });
    if (!activity)
      return socket.to(user.id).emit("error", "invalid activity id");

    if (!isUserActivityOwnerOrSuperuser(user, activity))
      return socket.to(user.id).emit("error", "Forbidden");

    if (activity.isSoftDeleted()) {
      await restoreWithChildTablesCascade({
        sequelize,
        table: Activity,
        childTables: [ActivityInstance],
        tablePKs: activity.id,
        tablePkAttributeName: "activity_id",
        rowDeletedAt: activity.deletedAt,
      });
    }

    socket.to(user.id).emit("activity:restore", activity);
  };

  socket.on("activity:read_all", readAllActivities);
  socket.on("activity:create", createActivity);
  socket.on("activity:edit", editActivity);
  socket.on("activity:delete", deleteActivity);
  socket.on("activity:restore", restoreActivity);
};
