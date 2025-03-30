# 🧾 Expense Tracker

An Expense Tracker application that allows users to record their expenses, categorize them, and retrieve summaries based on daily, weekly, monthly, and yearly timeframes.

## 🎥 Demo Video
[Watch the demo](https://drive.google.com/file/d/1s_ZbGrv3gbv52gWdi5bi4-fpkFcacyEP/view?usp=sharing)

## 🚀 Features

- **User Authentication:** Secure user login and registration using email.
- **Expense Management:** Add, update, and delete expenses with amount, category, description, and date.
- **Manual Date Entry:** Users can manually add the date for each expense.
- **Category Summaries:** Group expenses by categories (e.g., Food, Transportation, etc.).
- **Date Filtering:** Retrieve expenses by day, week, month, or year.
- **Visual Data Representation:**
  - **Pie Chart:** Display expense breakdown by category for daily, weekly, and monthly using `fl_chart` package.
  - **Bar Chart:** Show expense trends for the last 15 days.
- **CSV Export:** Download and export expenses to CSV format to the user's device.
- **Time Zone Handling:** Stores dates in IST (Indian Standard Time) as strings.
- **State Management:** Utilized Riverpod for managing application state.
- **No Data Animation:** Displays a Lottie animation when no data is found.

## 🛠️ Tech Stack

- **Backend:** Node.js with Express
- **Database:** PostgreSQL with Prisma ORM
- **Frontend:** Flutter (for mobile application)
- **State Management:** Riverpod
- **Local Storage:** SharedPreferences (to store user session data)

## 📂 Project Structure

```
├── prisma/              # Prisma schema and migrations
├── src/
│   ├── routes/         # API routes
│   ├── utils.js        # Helper functions (date handling, etc.)
│   └── index.js        # Main entry point
└── README.md
```

## 📊 Database Schema

```prisma
model User {
  id          String        @id @default(cuid())
  email       String        @unique
  name        String
  password    String
  createdAt   DateTime      @default(now())
  updatedAt   DateTime      @updatedAt
  expenseData ExpenseData[]
}

enum Category {
  Food
  Transportation
  Shopping
  Entertainment
  Other
}

model ExpenseData {
  id          String   @id @default(cuid())
  amount      Int
  description String
  category    Category
  date        DateTime
  User        User?    @relation(fields: [userId], references: [id])
  userId      String?
}
```

## 📌 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/expense-tracker.git
cd expense-tracker
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Set Up Environment Variables

Create a `.env` file in the root directory:

```
DATABASE_URL="postgresql://youruser:yourpassword@localhost:5432/yourdbname"
```

### 4. Run Migrations

```bash
npx prisma migrate dev --name init
```

### 5. Start the Server

```bash
npm run dev
```

## 📤 API Endpoints

### User Authentication

- **POST /api/v1/user/signup – Register a new user**
- **POST /api/v1/user/login** – Authenticate and receive a token

### Expense Management

- **POST /api/v1/expense/add** – Add a new expense
- **GET /api/v1/expense/filter?filter=daily – Fetch user expenses (supports filtering by daily, weekly, monthly, yearly)**
- **GET /api/v1/expense/get-summary – Fetches user's past 15 days expense**

### Example Payload (Add Expense)

```json
{
  "amount": 1500,
  "description": "Dinner at a restaurant",
  "category": "Food",
  "date": "2024-03-29"
}
```

## 📌 Future Improvements

- Add analytics for expense patterns
- Implement user notifications for spending limits
- Improve CSV export with customizable filters
- Add update and delete functionality for expenses

