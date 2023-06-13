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

exports.instancesRouter = router;
