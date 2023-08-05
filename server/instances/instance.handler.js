const {
  Activity,
  Icon,
  IconMetadata,
  User,
  ActivityInstance,
} = require("../models");
const { isUserActivityOwnerOrSuperuser } = require("../utilities");

module.exports = (io, socket) => {
  const readAllInstances = async (callback) => {
    const user = socket.request.user;

    let instances = [];

    if (user.is_super_user) {
      instances = await ActivityInstance.findAll({
        include: { model: Activity, as: "activity" },
      });
    } else {
      instances = await ActivityInstance.findAll({
        where: { "$activity.user_id$": user.id },
        include: { model: Activity, as: "activity", required: true },
      });
    }

    callback(instances);
  };

  const createInstance = async (payload) => {
    const user = socket.request.user;

    const activity = await Activity.findByPk(payload.activity_id);

    if (!isUserActivityOwnerOrSuperuser(user, activity))
      return io.in(user.id).emit("error", "Forbidden");

    if (!activity)
      return io.in(user.id).emit("error", "invalid activity id provided");

    const { id = null, start_at, end_at, comment, createdAt = null } = payload;

    const instance = await ActivityInstance.create({
      id,
      start_at,
      end_at,
      comment,
      activity_id: activity.id,
      createdAt,
    });

    io.in(user.id).emit("instance:create", instance);
  };

  const editInstance = async (payload) => {
    const user = socket.request.user;

    const activityInstance = await ActivityInstance.findByPk(payload.id, {
      include: { model: Activity, as: "activity" },
    });

    if (!activityInstance)
      return io
        .in(user.id)
        .emit("error", "invalid activityInstance id provided");

    if (!isUserActivityOwnerOrSuperuser(user, activityInstance.activity))
      return io.in(user.id).emit("error", "Forbidden");

    const { start_at, end_at, comment, activity_id } = payload;

    let activity;
    if (activity_id) activity = await Activity.findByPk(activity_id);

    if (activity_id && !activity)
      return io.in(user.id).emit("error", "invalid activity id provided");

    const editedInstance = await activityInstance.update({
      start_at,
      end_at,
      comment,
      activity_id,
    });

    io.in(user.id).emit("instance:edit", editedInstance);
  };

  const deleteInstance = async (payload) => {
    const user = socket.request.user;

    const activityInstance = await ActivityInstance.findByPk(payload, {
      include: { model: Activity, as: "activity" },
    });

    if (!activityInstance)
      return io
        .in(user.id)
        .emit("error", "invalid activityInstance id provided");

    if (!isUserActivityOwnerOrSuperuser(user, activityInstance.activity))
      return io.in(user.id).emit("error", "Forbidden");

    await activityInstance.destroy();

    io.in(user.id).emit("instance:delete", payload);
  };

  const restoreInstance = async (payload) => {
    const user = socket.request.user;

    const activityInstance = await ActivityInstance.findByPk(payload.id, {
      paranoid: false,
      include: { model: Activity, as: "activity" },
    });

    if (!activityInstance)
      return io
        .in(user.id)
        .emit("error", "invalid activityInstance id provided");

    if (!isUserActivityOwnerOrSuperuser(user, activityInstance.activity))
      return io.in(user.id).emit("error", "Forbidden");

    if (activityInstance.isSoftDeleted()) {
      await activityInstance.restore();
    }

    io.in(user.id).emit("instance:restore", payload);
  };

  const deleteMultipleInstances = async (payload) => {
    const user = socket.request.user;

    const { ids } = payload;

    if (!ids)
      return io
        .in(user.id)
        .emit(
          "error",
          'body parameter "ids" required for instances delete endpoint'
        );

    let instancesToDestroy;

    if (user.is_super_user) {
      instancesToDestroy = await ActivityInstance.findAll({
        where: { id: ids },
        include: { model: Activity, as: "activity", required: true },
      });
    } else {
      instancesToDestroy = await ActivityInstance.findAll({
        where: { id: ids, "$activity.user_id$": user.id },
        include: { model: Activity, as: "activity", required: true },
      });
    }

    await ActivityInstance.destroy({
      where: { id: instancesToDestroy.map((instance) => instance.id) },
    });

    io.in(user.id).emit("instance:delete_multiple", payload);
  };

  const restoreMultipleInstances = async (payload) => {
    const user = socket.request.user;

    const { ids } = payload;

    if (!ids)
      return io
        .in(user.id)
        .emit(
          "error",
          'body parameter "ids" required for instances delete endpoint'
        );

    if (user.is_super_user) {
      whereClause = { id: ids };
    } else {
      whereClause = { id: ids, "$activity.user_id$": user.id };
    }

    let instancesToRestore = await ActivityInstance.findAll({
      where: whereClause,
      include: { model: Activity, as: "activity", required: true },
      paranoid: false,
    });

    await ActivityInstance.restore({
      where: { id: instancesToRestore.map((instance) => instance.id) },
    });

    io.in(user.id).emit("instance:restore_multiple", instancesToRestore);
  };

  socket.on("instance:read_all", readAllInstances);
  socket.on("instance:create", createInstance);
  socket.on("instance:edit", editInstance);
  socket.on("instance:delete", deleteInstance);
  socket.on("instance:delete_multiple", deleteMultipleInstances);
  socket.on("instance:restore", restoreInstance);
  socket.on("instance:restore_multiple", restoreMultipleInstances);
};
