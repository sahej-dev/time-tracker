const express = require("express");

const { Activity, Icon, IconMetadata, User } = require("../models");
const { allowOnlySuperuser } = require("../middleware");
const { isActivityOwnerOrSuperuser } = require("./utilities");

const router = express.Router();

router.get("/", allowOnlySuperuser, async (req, res, next) => {
  console.log("ACTIVITIES");
  res.value = await Activity.findAll();
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
      icon_family,
      icon_package,
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
    } else if (icon_codepoint && icon_family && icon_package) {
      const icons = await Icon.findAll({
        where: { codepoint: icon_codepoint },
        include: IconMetadata,
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
          metadata = IconMetadata.create({
            font_family: icon_family,
            font_package: icon_package,
          });
        }

        icon = Icon.create({
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
        .end(
          "either icon_id, or all of icon_codepoint, icon_family, and icon_package must be provided"
        );
    }

    res.value = createdActivity;
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

  res.value = activity;
  next();
});

router.put("/:id", async (req, res, next) => {
  const activity = await Activity.findByPk(req.params.id);
  if (!activity) return res.status(400).end("invalid id provided");
  if (!isActivityOwnerOrSuperuser(req, activity))
    return res.status(403).end("Forbidden");

  const { label, color, icon_id, icon_codepoint, icon_family, icon_package } =
    req.body;

  if (icon_id) {
    const icon = await Icon.findByPk(icon_id);
    if (!icon) return res.status(400).send("invalid icon_id provided");

    await activity.update({
      label,
      color,
      icon_id,
    });
  } else if (icon_codepoint && icon_family && icon_package) {
    const icons = await Icon.findAll({
      where: { codepoint: icon_codepoint },
      include: IconMetadata,
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
        metadata = IconMetadata.create({
          font_family: icon_family,
          font_package: icon_package,
        });
      }

      icon = Icon.create({
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
    activity.update({
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
    if (!isActivityOwnerOrSuperuser(req, activity))
      return res.status(403).end("Forbidden");

    await activity.destroy();
    res.status(200).end();
  } catch (error) {
    next(error);
  }
});

exports.activityRouter = router;
