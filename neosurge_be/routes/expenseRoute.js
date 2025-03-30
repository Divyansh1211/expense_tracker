const express = require("express");
const { client } = require("../utils");
const { authMiddleware } = require("../authMiddleware");
const { format, toZonedTime } = require("date-fns-tz");
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
        date: new Date(
          format(toZonedTime(new Date(date), "Asia/Kolkata"), "yyyy-MM-dd")
        ),
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
        gte: new Date(
          format(toZonedTime(new Date(), "Asia/Kolkata"), "yyyy-MM-dd")
        ),
        lte: new Date(
          format(toZonedTime(new Date(), "Asia/Kolkata"), "yyyy-MM-dd") +
            "T23:59:59.999Z"
        ),
      };
      break;
    case "weekly":
      const todayIST = toZonedTime(new Date(), "Asia/Kolkata");
      const startOfWeekIST = new Date(todayIST);
      startOfWeekIST.setDate(todayIST.getDate() - todayIST.getDay());
      const startDateStr = format(startOfWeekIST, "yyyy-MM-dd");
      const endDateStr = format(todayIST, "yyyy-MM-dd") + "T23:59:59.999Z";
      dateFilter = {
        gte: new Date(startDateStr),
        lte: new Date(endDateStr),
      };
      break;
    case "monthly":
      const currentDate = toZonedTime(new Date(), "Asia/Kolkata");
      const startOfMonth = new Date(
        currentDate.getFullYear(),
        currentDate.getMonth(),
        1
      );

      dateFilter = {
        gte: new Date(
          format(toZonedTime(startOfMonth, "Asia/Kolkata"), "yyyy-MM-dd")
        ),
        lte: new Date(
          format(toZonedTime(new Date(), "Asia/Kolkata"), "yyyy-MM-dd") +
            "T23:59:59.999Z"
        ),
      };
      break;
    case "yearly":
      const yearDate = toZonedTime(new Date(), "Asia/Kolkata");
      const startOfYear = new Date(yearDate.getFullYear(), 0, 1);

      dateFilter = {
        gte: new Date(
          format(toZonedTime(startOfYear, "Asia/Kolkata"), "yyyy-MM-dd")
        ),
        lte: new Date(
          format(toZonedTime(new Date(), "Asia/Kolkata"), "yyyy-MM-dd") +
            "T23:59:59.999Z"
        ),
      };
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
