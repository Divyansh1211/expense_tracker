class Config {
  // static const String backendUrl = "http://192.168.29.217:5000/api/v1";
  static const String backendUrl = "http://neo-be.divyansh.lol/api/v1";
  static const String createUser = "$backendUrl/user/signup";
  static const String login = "$backendUrl/user/login";
  static const String addExpense = "$backendUrl/expense/add";
  static const String filterExpenses = "$backendUrl/expense/filter?filter=";
  static const String getSummary = "$backendUrl/expense/get-summary";
}
