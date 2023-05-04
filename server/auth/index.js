const express = require("express");
const bcrypt = require("bcrypt");

const { User } = require("../models");
const { getJwtTokenResponse } = require("./utilities");

const router = express.Router();

router.post("/signup", async (req, res, next) => {
  const { email, password, first_name, last_name, username, phone } = req.body;

  bcrypt.hash(password, 10, async function (err, hashedPassword) {
    if (err) next(err);

    try {
      const user = await User.create({
        username,
        first_name,
        last_name,
        email,
        password: hashedPassword,
        phone,
      });

      res.value = getJwtTokenResponse({
        id: user.id,
      });
      next();
    } catch (error) {
      if (error.name === "SequelizeUniqueConstraintError") {
        const errors = error.errors.map((e) => {
          return { msg: e.message, path: e.path };
        });
        res.status(400).json({ errors });
      } else {
        next(error);
      }
    }
  });
});

router.post("/signin", async (req, res, next) => {
  const { email, password } = req.body;

  const user = await User.findOne({ where: { email } });

  if (!user) res.status(403);

  bcrypt.compare(password, user.password, function (err, result) {
    if (err) next(err);

    if (result === false) {
      res.status(403).end("Forbidden");
      return;
    }

    res.value = getJwtTokenResponse({
      id: user.id,
    });
    next();
  });
});

exports.authRouter = router;
