const express = require("express");
const { userRouter } = require("./routes/userRoute");
const { expenseRouter } = require("./routes/expenseRoute");
const app = express();
const PORT = 3000;

app.use(express.json());
app.use("/api/v1/user", userRouter);
app.use("/api/v1/expense", expenseRouter);

app.listen(PORT, () => {
  console.log("Server is running on port 3000");
});
