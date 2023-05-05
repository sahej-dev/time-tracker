const express = require("express");
const bcrypt = require("bcrypt");

const { User } = require("../models");
const { allowOnlySuperuser } = require("../middleware");
const { isAdminOrSelf } = require("./middlewares");

const router = express.Router();

router.get("/", allowOnlySuperuser, async (req, res, next) => {
  console.log("USERS");
  res.value = await User.findAll();
  next();
});

router.delete("/", allowOnlySuperuser, async (req, res, next) => {
  try {
    const numDeleted = await User.destroy({ where: { id: req.body.ids } });
    res.status(200).json(numDeleted).end();
  } catch (error) {
    next(error);
  }
});

router.get("/:id", isAdminOrSelf, async (req, res, next) => {
  res.value = await User.findByPk(req.params.id);
  next();
});

router.put("/:id", isAdminOrSelf, async (req, res, next) => {
  const { email, password, first_name, last_name, username, phone } = req.body;

  bcrypt.hash(password, 10, async function (err, hashedPassword) {
    if (err) {
      if (err.message !== "data and salt arguments required") next(err);
    }

    try {
      await User.update(
        {
          username,
          first_name,
          last_name,
          email,
          password: hashedPassword,
          phone,
        },
        { where: { id: req.params.id } }
      );

      res.status(200).end();
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

router.delete("/:id", isAdminOrSelf, async (req, res, next) => {
  try {
    await User.destroy({ where: { id: req.params.id } });
    res.status(200).end();
  } catch (error) {
    next(error);
  }
});

exports.userRouter = router;
