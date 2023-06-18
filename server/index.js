const fs = require("fs");

const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const rateLimit = require("express-rate-limit");

const { initialiseDatabaseConnection } = require("./db/init");
const { logger } = require("./logs/logger_config");
const { authenticateToken } = require("./middleware");
const {
  deleteAllNestedProperties,
  setNestedFalseyValuesToNull,
} = require("./utilities");

const { authRouter } = require("./auth");
const { userRouter } = require("./users");
const { activityRouter } = require("./activities");
const { instancesRouter } = require("./instances");

const app = express();
const port = process.env.PORT || 2000;

initialiseDatabaseConnection();

const whitelist = ["http://localhost:3000"];
const corsOptions = {
  origin: function (origin, callback) {
    if (whitelist.indexOf(origin) !== -1 || origin === undefined) {
      callback(null, true);
    } else {
      callback(new Error(`Not allowed by CORS origin ${origin}`));
    }
  },
  optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
};

const rateLimiterConfig = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per `window` (here, per 15 minutes)
  standardHeaders: false, // Return rate limit info in the `RateLimit-*` headers
  legacyHeaders: false, // Disable the `X-RateLimit-*` headers
});

app.use(express.json());
app.use(helmet());
app.use(cors(corsOptions));
app.use(logger);
app.use(rateLimiterConfig);

app.disable("x-powered-by");

app.post("*", function removeFalseyValues(req, res, next) {
  setNestedFalseyValuesToNull(req.body);
  next();
});

app.put("*", function removeFalseyValues(req, res, next) {
  setNestedFalseyValuesToNull(req.body);
  next();
});

app.delete("*", function removeFalseyValues(req, res, next) {
  setNestedFalseyValuesToNull(req.body);
  next();
});

app.get("/", (req, res) => {
  res.send("Running Time Track");
});

app.use("/api/v1/auth", authRouter);
app.use(authenticateToken);

app.use("/api/v1/users", userRouter);
app.use("/api/v1/activities", activityRouter);
app.use("/api/v1/instances", instancesRouter);

app.use((err, req, res, next) => {
  fs.appendFile(
    `${__dirname}/logs/errors.log`,
    `${new Date().toUTCString()}: ${err.name} ${err.stack} \n\n`,
    (err) => {
      if (err) {
        console.error(err);
      }
    }
  );
  if (!res.headersSent) res.status(500).send("Uncaught Error");
});

app.use("*", function removeFalseyValues(req, res, next) {
  // console.log("RES VAL: ", res.value);
  // setNestedFalseyValuesToNull(res.value);
  next();
});

app.use(function parseResponseValue(req, res, next) {
  if (!res.value) {
    res.end();
    return;
  }

  const resJson = JSON.parse(JSON.stringify(res.value));
  deleteAllNestedProperties(resJson, "deletedAt");
  // if (!res.includeCreatedAt) deleteAllNestedProperties(resJson, "createdAt");
  if (!res.includeUpdatedAt) deleteAllNestedProperties(resJson, "updatedAt");
  deleteAllNestedProperties(resJson, "password");

  res.json(resJson);
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
  console.log(`NODE_ENV is: ${process.env.NODE_ENV}`);
});
