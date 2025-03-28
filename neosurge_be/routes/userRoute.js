const express = require("express");
const userRouter = express.Router();
const bcrypt = require("bcrypt");
const { client } = require("../utils");
const jwt = require("jsonwebtoken");

userRouter.post("/signup", async (req, res) => {
  const { name, email, password } = req.body;
  const user = await client.user.findUnique({
    where: {
      email,
    },
  });

  if (user) {
    return res.status(400).json({
      success: false,
      message: "User already exists",
    });
  }
  const hashPassword = await bcrypt.hash(password, 10);
  await client.user.create({
    data: {
      name,
      email,
      password: hashPassword,
    },
  });
  res.status(201).json({
    success: true,
    message: "User created successfully",
  });
});

userRouter.post("/login", async (req, res) => {
  const { email, password } = req.body;
  const user = await client.user.findUnique({
    where: {
      email,
    },
  });
  if (!user) {
    return res.status(400).json({
      success: false,
      message: "User not found",
    });
  }
  const isPasswordValid = await bcrypt.compare(password, user.password);
  if (!isPasswordValid) {
    return res.status(400).json({
      success: false,
      message: "Invalid password",
    });
  } else {
    const token = jwt.sign({ id: user.id }, "secret");
    res.status(200).json({
      success: true,
      message: "Login successful",
      token,
      user,
    });
  }
});

module.exports = { userRouter };
