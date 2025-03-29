# 📐 Design Notes for Expense Tracker

## 🎯 Architectural Overview

The Expense Tracker application is designed with a **modular architecture**, ensuring separation of concerns between the frontend, backend, and database. This approach facilitates better maintainability, scalability, and ease of feature expansion.

### 🛠️ System Components

1. **Frontend (Flutter):**

   - Manages the user interface and interactions.
   - Utilizes `fl_chart` for visualizing expenses through pie and bar charts.
   - Stores authentication tokens and user data locally using **SharedPreferences**.

2. **Backend (Node.js + Express):**

   - Handles API endpoints for user authentication and expense management.
   - Implements business logic for filtering and grouping expenses.
   - Uses **Prisma ORM** for database operations, enhancing type safety and query optimization.

3. **Database (PostgreSQL):**

   - Stores user and expense data.
   - Optimized schema for quick retrieval by date ranges (daily, weekly, monthly, yearly).

## 📊 Data Flow

1. **User Authentication:**

   - Users sign up and log in via email.
   - Upon successful login, a **JWT token** is generated and stored locally.

2. **Expense Management:**

   - Users submit expenses with amount, category, description, and date.
   - Data is sent to the backend and stored in PostgreSQL.
   - Expenses can be filtered by timeframes (daily, weekly, monthly, yearly).

## 🔍 Unique Feature Reasoning

### 1. **Manual Date Entry**

- Users can backdate expenses to maintain accurate financial tracking.

### 2. **Time Zone Handling (IST)**

- Dates are stored as **DateTime** in PostgreSQL, ensuring precise time tracking and accurate filtering.

### 3. **Dynamic Data Visualization**

- **Pie Chart**: Provides a categorical breakdown for daily, weekly, and monthly expenses.
- **Bar Chart**: Displays a 15-day trend for better insights on spending patterns.

### 4. **CSV Export**

- Users can export expenses as CSV files for offline analysis and record-keeping.

### 5. **Lottie Animation for No Data**

- Enhances UX by displaying a friendly animation when no expenses are available.

## 📌 Future Considerations

1. **Update & Delete Features**

   - Allow users to modify and remove existing expenses.

2. **Expense Analytics**

   - Introduce spending patterns and visualization over custom date ranges.

3. **Notifications**

   - Implement alerts for budget thresholds and spending anomalies.

4. **Multi-Time Zone Support**

   - Extend the system to dynamically adjust time zones based on user location.



