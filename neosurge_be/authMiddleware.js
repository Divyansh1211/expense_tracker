const jwt = require("jsonwebtoken");

async function authMiddleware(req, res, next) {
  const token = req.headers.authorization;
  if (!token) {
    return res.status(401).json({ message: "Unauthorized" });
  }
  try {
    const decodedToken = jwt.verify(token, "secret");
    req.userId = decodedToken;
    next();
  } catch (err) {
    return res.status(401).json({ message: "Unauthorized" });
  }
}

module.exports = { authMiddleware };
