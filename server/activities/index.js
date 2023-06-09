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
  console.log("ACTIVITIES");
  if (
    req.query.by_user &&
    (req.query.by_user === req.user.id || req.user.is_super_user)
  ) {
    res.value = await Activity.findAll({
      where: { user_id: req.query.by_user },
      include: {
        model: Icon,
        as: "icon",
        include: { model: IconMetadata, as: "metadata" },
      },
    });
  } else if (req.user.is_super_user) {
    res.value = await Activity.findAll({
      include: {
        model: Icon,
        as: "icon",
        include: { model: IconMetadata, as: "metadata" },
      },
    });
  } else {
    return res.status(403).send("Forbidden");
  }
  next();
});

router.post(
  "/",
  async function byAdminOrForSelf(req, res, next) {
    if (
      req.body?.user_id &&
      req.body.user_id !== req.user.id &&
      !req.user.is_super_user
    )
      return res.status(403).end("Forbidden");

    next();
  },
  async (req, res, next) => {
    const {
      label,
      color,
      user_id = req.user.id,
      icon_id,
      icon_codepoint,
      icon_family = null,
      icon_package = null,
    } = req.body;

    let createdActivity;

    if (icon_id) {
      const icon = await Icon.findByPk(icon_id);
      if (!icon) return res.status(400).end("invalid icon_id provided");

      createdActivity = await Activity.create({
        label,
        color,
        user_id,
        icon_id,
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
        label,
        color,
        user_id,
        icon_id: icon.id,
      });
    } else {
      return res
        .status(400)
        .end("either icon_id, or icon_codepoint must be provided");
    }

    res.value = await Activity.findByPk(createdActivity.id, {
      include: {
        model: Icon,
        as: "icon",
        include: { model: IconMetadata, as: "metadata" },
      },
    });
    next();
  }
);

router.delete("/", allowOnlySuperuser, async (req, res, next) => {
  try {
    const numDeleted = await User.destroy({ where: { id: req.body.ids } });
    res.status(200).json(numDeleted).end();
  } catch (error) {
    next(error);
  }
});

router.get("/:id", async (req, res, next) => {
  const activity = await Activity.findByPk(req.params.id);
  if (!isActivityOwnerOrSuperuser(req, activity))
    return res.status(403).end("Forbidden");

  if (!activity) return res.status(401).end("invalid activity id provided");

  res.value = activity;
  next();
});

router.get("/:id/instances", async (req, res, next) => {
  const activity = await Activity.findByPk(req.params.id, {
    include: { model: ActivityInstance, as: "instances" },
  });

  if (!isActivityOwnerOrSuperuser(req, activity))
    return res.status(403).end("Forbidden");

  if (!activity) return res.status(401).end("invalid activity id provided");

  res.value = activity.instances;
  next();
});

router.post("/:id/instances", async (req, res, next) => {
  const activity = await Activity.findByPk(req.params.id);

  if (!isActivityOwnerOrSuperuser(req, activity))
    return res.status(403).end("Forbidden");

  if (!activity) return res.status(401).end("invalid activity id provided");

  const { start_at, end_at, comment } = req.body;

  res.value = await ActivityInstance.create({
    start_at,
    end_at,
    comment,
    activity_id: activity.id,
  });
  next();
});

router.put("/:id/instances/:instanceId", async (req, res, next) => {
  const activityInstance = await ActivityInstance.findByPk(
    req.params.instanceId,
    {
      include: { model: Activity, as: "activity" },
    }
  );

  if (!activityInstance)
    return res.status(401).end("invalid activityInstance id provided");

  if (!isActivityOwnerOrSuperuser(req, activityInstance.activity))
    return res.status(403).end("Forbidden");

  const { start_at, end_at, comment } = req.body;

  res.value = await activityInstance.update({
    start_at,
    end_at,
    comment,
  });
  next();
});

router.delete("/:id/instances/:instanceId", async (req, res, next) => {
  const activityInstance = await ActivityInstance.findByPk(
    req.params.instanceId,
    {
      include: { model: Activity, as: "activity" },
    }
  );

  if (!activityInstance)
    return res.status(401).end("invalid activityInstance id provided");

  if (!isActivityOwnerOrSuperuser(req, activityInstance.activity))
    return res.status(403).end("Forbidden");

  await activityInstance.destroy();

  res.value = activityInstance;
  next();
});

router.put("/:id", async (req, res, next) => {
  const activity = await Activity.findByPk(req.params.id, {
    include: {
      model: Icon,
      as: "icon",
      include: { model: IconMetadata, as: "metadata" },
    },
  });
  if (!activity) return res.status(400).end("invalid id provided");
  if (!isActivityOwnerOrSuperuser(req, activity))
    return res.status(403).end("Forbidden");

  const {
    label,
    color,
    icon_id,
    icon_codepoint,
    icon_family = null,
    icon_package = null,
  } = req.body;

  if (icon_id) {
    const icon = await Icon.findByPk(icon_id);
    if (!icon) return res.status(400).send("invalid icon_id provided");

    await activity.update({
      label,
      color,
      icon_id,
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
    });
  } else {
    await activity.update({
      label,
      color,
    });
  }

  res.value = activity;
  next();
});

router.delete("/:id", async (req, res, next) => {
  try {
    const activity = await Activity.findByPk(req.params.id);
    if (!activity) return res.status(401).end("invalid activity id");

    if (!isActivityOwnerOrSuperuser(req, activity))
      return res.status(403).end("Forbidden");

    await activity.destroy();
    res.status(200).end();
  } catch (error) {
    next(error);
  }
});

router.patch("/:id", async (req, res, next) => {
  try {
    const activity = await Activity.findByPk(req.params.id, {
      paranoid: false,
      include: {
        model: Icon,
        as: "icon",
        include: { model: IconMetadata, as: "metadata" },
      },
    });
    if (!activity) return res.status(401).end("invalid activity id");

    if (!isActivityOwnerOrSuperuser(req, activity))
      return res.status(403).end("Forbidden");

    if (activity.isSoftDeleted()) {
      await activity.restore();
    }

    res.value = activity;
    next();
  } catch (error) {
    next(error);
  }
});

exports.activityRouter = router;
