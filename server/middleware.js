const jwt = require("jsonwebtoken");
const { User } = require("./models");

async function allowOnlySuperuser(req, res, next) {
  if (!req.user.is_super_user) {
    res.status(403).end("Forbidden");
    return;
  }
  next();
}

async function authenticateToken(req, res, next) {
  console.log("in authenticate middleware");
  if (req.url.includes("/auth")) next();
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) return res.sendStatus(401);

  jwt.verify(token, process.env.TOKEN_SECRET, async (err, user) => {
    if (process.env.NODE_ENV !== "production") console.log("AUTH ERR:", err);

    if (err) return res.sendStatus(403);

    const dbUser = await User.findByPk(user.id);
    req.user = {
      ...user,
      ...dbUser.dataValues,
    };
    if (process.env.NODE_ENV !== "production") console.log("USER: ", req.user);

    next();
  });
}

exports.authenticateToken = authenticateToken;
exports.allowOnlySuperuser = allowOnlySuperuser;
