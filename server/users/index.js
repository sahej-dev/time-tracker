const express = require("express");

const { User } = require("../models");
const { allowOnlySuperuser } = require("../middleware");

const router = express.Router();

router.get("/", allowOnlySuperuser, async (req, res, next) => {
  console.log("USERS");
  res.value = await User.findAll();
  next();
});

router.get(
  "/:id",
  async (req, res, next) => {
    if (req.user.id !== req.params.id && !req.user.is_super_user) {
      res.status(403).end("Forbidden");
      return;
    }
    next();
  },
  async (req, res, next) => {
    res.value = await User.findByPk(req.params.id);
    next();
  }
);

exports.userRouter = router;
