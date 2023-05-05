async function isAdminOrSelf(req, res, next) {
  if (req.user.id !== req.params.id && !req.user.is_super_user) {
    res.status(403).end("Forbidden");
    return;
  }
  next();
}

exports.isAdminOrSelf = isAdminOrSelf;
