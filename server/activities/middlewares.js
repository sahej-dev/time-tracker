const { Activity } = require("../models");

async function isAdminOrOwner(req, res, next) {
  const activity = await Activity.findByPk(req.params.id);
  if (
    (!activity || req.user.id !== activity.user_id) &&
    !req.user.is_super_user
  ) {
    res.status(403).end("Forbidden");
    return;
  }
  next();
}

exports.isAdminOrOwner = isAdminOrOwner;
