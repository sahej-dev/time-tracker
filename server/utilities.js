const { Op } = require("sequelize");

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

function isUserActivityOwnerOrSuperuser(user, activity) {
  return (activity && user.id === activity.user_id) || user.is_super_user;
}

async function deleteWithChildTablesCascade({
  sequelize,
  table,
  childTables,
  tablePKs,
  tablePkAttributeName,
  options = {},
}) {
  const transaction = await sequelize.transaction();

  let childrenWhereClause = { ...options.where };
  childrenWhereClause[tablePkAttributeName] = tablePKs;

  let tableWhereClause = { ...options.where };
  tableWhereClause[table.primaryKeyAttribute] = tablePKs;

  try {
    if (childTables)
      await Promise.all(
        childTables.map(async (childTable) =>
          childTable.destroy({
            ...options,
            where: childrenWhereClause,
            transaction,
          })
        )
      );

    await table.destroy({
      ...options,
      where: tableWhereClause,
      transaction,
    });

    await transaction.commit();
  } catch (error) {
    await transaction.rollback();
    throw error;
  }
}

async function restoreWithChildTablesCascade({
  sequelize,
  table,
  childTables,
  tablePKs,
  tablePkAttributeName,
  rowDeletedAt,
  options = {},
}) {
  const transaction = await sequelize.transaction();

  let childrenWhereClause = { ...options.where };
  childrenWhereClause[tablePkAttributeName] = tablePKs;
  if (rowDeletedAt)
    childrenWhereClause["deletedAt"] = { [Op.gte]: rowDeletedAt };

  let tableWhereClause = { ...options.where };
  tableWhereClause[table.primaryKeyAttribute] = tablePKs;

  try {
    if (childTables)
      await Promise.all(
        childTables.map(async (childTable) =>
          childTable.restore({
            ...options,
            where: childrenWhereClause,
            transaction,
          })
        )
      );

    await table.restore({
      ...options,
      where: tableWhereClause,
      transaction,
    });

    await transaction.commit();
  } catch (error) {
    await transaction.rollback();
    throw error;
  }
}

exports.deleteAllNestedProperties = deleteAllNestedProperties;
exports.setNestedFalseyValuesToNull = setNestedFalseyValuesToNull;
exports.isActivityOwnerOrSuperuser = isActivityOwnerOrSuperuser;
exports.isUserActivityOwnerOrSuperuser = isUserActivityOwnerOrSuperuser;
exports.deleteWithChildTablesCascade = deleteWithChildTablesCascade;
exports.restoreWithChildTablesCascade = restoreWithChildTablesCascade;
