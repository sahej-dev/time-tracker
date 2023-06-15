const express = require("express");

const {
  Activity,
  Icon,
  IconMetadata,
  User,
  ActivityInstance,
} = require("../models");
const { allowOnlySuperuser } = require("../middleware");
const { isActivityOwnerOrSuperuser } = require("../utilities");

const router = express.Router();

router.get("/", async (req, res, next) => {
  if (req.user.is_super_user) {
    const instances = ActivityInstance.findAll({
      include: { model: Activity, as: "activity" },
    });

    res.value = instances;
    return next();
  }

  const instances = await ActivityInstance.findAll({
    where: { "$activity.user_id$": req.user.id },
    include: { model: Activity, as: "activity", required: true },
  });

  res.value = instances;
  next();
});

router.put("/:id", async (req, res, next) => {
  const activityInstance = await ActivityInstance.findByPk(req.params.id, {
    include: { model: Activity, as: "activity" },
  });

  if (!activityInstance)
    return res.status(401).end("invalid activityInstance id provided");

  if (!isActivityOwnerOrSuperuser(req, activityInstance.activity))
    return res.status(403).end("Forbidden");

  const { start_at, end_at, comment, activity_id } = req.body;

  let activity;
  if (activity_id) activity = await Activity.findByPk(activity_id);

  if (activity_id && !activity)
    return res.status(401).end("invalid activity id provided");

  res.value = await activityInstance.update({
    start_at,
    end_at,
    comment,
    activity_id,
  });
  next();
});

router.delete("/:id", async (req, res, next) => {
  const activityInstance = await ActivityInstance.findByPk(req.params.id, {
    include: { model: Activity, as: "activity" },
  });

  if (!activityInstance)
    return res.status(401).end("invalid activityInstance id provided");

  if (!isActivityOwnerOrSuperuser(req, activityInstance.activity))
    return res.status(403).end("Forbidden");

  try {
    await activityInstance.destroy();
    return res.status(200).end();
  } catch (error) {
    next(error);
  }
});

router.delete("/", async (req, res, next) => {
  const { ids } = req.body;

  if (!ids)
    return res
      .status(401)
      .send('body parameter "ids" required for instances delete endpoint');

  try {
    let instancesToDestroy;
    if (req.user.is_super_user) {
      instancesToDestroy = await ActivityInstance.findAll({
        where: { id: ids },
        include: { model: Activity, as: "activity", required: true },
      });
    } else {
      instancesToDestroy = await ActivityInstance.findAll({
        where: { id: ids, "$activity.user_id$": req.user.id },
        include: { model: Activity, as: "activity", required: true },
      });
    }

    await ActivityInstance.destroy({
      where: { id: instancesToDestroy.map((instance) => instance.id) },
    });

    return res.status(200).end();
  } catch (error) {
    console.log(error);
    next(error);
  }
});

router.patch("/:id", async (req, res, next) => {
  const activityInstance = await ActivityInstance.findByPk(req.params.id, {
    paranoid: false,
    include: { model: Activity, as: "activity" },
  });

  if (!activityInstance)
    return res.status(401).end("invalid activityInstance id provided");

  if (!isActivityOwnerOrSuperuser(req, activityInstance.activity))
    return res.status(403).end("Forbidden");

  try {
    if (activityInstance.isSoftDeleted()) {
      await activityInstance.restore();
    }
    res.value = activityInstance;
    next();
  } catch (error) {
    next(error);
  }
});

router.patch("/", async (req, res, next) => {
  const { ids } = req.body;

  if (!ids)
    return res
      .status(401)
      .send('body parameter "ids" required for instances delete endpoint');

  try {
    if (req.user.is_super_user) {
      whereClause = { id: ids };
    } else {
      whereClause = { id: ids, "$activity.user_id$": req.user.id };
    }

    let instancesToRestore = await ActivityInstance.findAll({
      where: whereClause,
      include: { model: Activity, as: "activity", required: true },
      paranoid: false,
    });

    await ActivityInstance.restore({
      where: { id: instancesToRestore.map((instance) => instance.id) },
    });

    res.value = instancesToRestore;
    next();
  } catch (error) {
    next(error);
  }
});

exports.instancesRouter = router;
