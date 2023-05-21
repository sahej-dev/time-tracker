function isActivityOwnerOrSuperuser(req, activity) {
  return (
    (activity && req.user.id === activity.user_id) || req.user.is_super_user
  );
}

exports.isActivityOwnerOrSuperuser = isActivityOwnerOrSuperuser;
