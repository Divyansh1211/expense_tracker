const express = require("express");
const { client } = require("../utils");
const { authMiddleware } = require("../authMiddleware");
const expenseRouter = express.Router();

expenseRouter.post("/add", authMiddleware, async (req, res) => {
  try {
    const { description, amount, category, date } = req.body;
    const userId = req.userId.id;
    const expense = await client.expenseData.create({
      data: {
        description,
        amount: parseInt(amount),
        category,
        date: new Date(date),
        userId,
      },
    });
    res.status(201).json({
      success: true,
      message: "Expense added successfully",
      expense,
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: err.message,
    });
  }
});

expenseRouter.delete("/delete/:id", authMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.userId.id;
    const expense = await client.expenseData.deleteMany({
      where: {
        id,
        userId,
      },
    });
    res.status(200).json({
      success: true,
      message: "Expense deleted successfully",
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: err.message,
    });
  }
});

expenseRouter.get("/filter", authMiddleware, async (req, res) => {
  const { filter } = req.query;
  const userId = req.userId.id;

  let dateFilter = {};

  switch (filter) {
    case "daily":
      dateFilter = {
        gte: new Date(new Date().setHours(0, 0, 0, 0)),
        // lte: new Date(),
      };
      break;
    case "weekly":
      const startOfWeek = new Date();
      startOfWeek.setDate(startOfWeek.getDate() - startOfWeek.getDay());
      dateFilter = { gte: startOfWeek, lte: new Date() };
      break;
    case "monthly":
      const startOfMonth = new Date(new Date().setDate(1));
      dateFilter = { gte: startOfMonth, lte: new Date() };
      break;
    case "yearly":
      const startOfYear = new Date(new Date().getFullYear(), 0, 1);
      dateFilter = { gte: startOfYear, lte: new Date() };
      break;
  }

  const expenses = await client.expenseData.groupBy({
    by: ["category"],
    where: {
      userId,
      date: dateFilter,
    },
    _sum: {
      amount: true,
    },
    orderBy: {
      _sum: {
        amount: "desc",
      },
    },
  });

  res.json({ expenses });
});

expenseRouter.get("/get-summary", authMiddleware, async (req, res) => {
  const userId = req.userId.id;
  // const startOfMonth = new Date(new Date().setDate(1));
  //last 15 days
  const startOfMonth = new Date(new Date().setDate(new Date().getDate() - 15));

  const summary = await client.expenseData.groupBy({
    by: ["date"],
    where: { userId, date: { gte: startOfMonth } },
    _sum: { amount: true },
    orderBy: {
      date: "asc",
    },
  });

  res.json({ summary });
});

module.exports = { expenseRouter };
