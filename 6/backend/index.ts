import dotenv from "dotenv";
dotenv.config({ path: "/app/secret/.env" });
import express from "express";

const app = express();

app.get("/", (req, res) => {
  res.json({ message: process.env.DATABASE_URL, port: process.env.PORT });
});

console.log(process.env.DATABASE_URL);

console.log(process.env.PORT);

app.listen(process.env.PORT);