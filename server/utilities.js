function deleteAllNestedProperties(obj, propertyName) {
  if (!obj) return;
  delete obj[propertyName];
  for (let v of Object.values(obj)) {
    if (v instanceof Object) {
      deleteAllNestedProperties(v, propertyName);
    }
  }
}

function setNestedFalseyValuesToNull(obj) {
  if (!obj) return;
  for (let k of Object.keys(obj)) {
    if (!obj[k]) obj[k] = null;
    else if (obj[k] instanceof Object) setNestedFalseyValuesToNull(obj[k]);
  }
}

function isActivityOwnerOrSuperuser(req, activity) {
  return (
    (activity && req.user.id === activity.user_id) || req.user.is_super_user
  );
}

exports.deleteAllNestedProperties = deleteAllNestedProperties;
exports.setNestedFalseyValuesToNull = setNestedFalseyValuesToNull;
exports.isActivityOwnerOrSuperuser = isActivityOwnerOrSuperuser;
