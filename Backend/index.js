import express from "express";
import newsApi from "./api-routes/news/index.js";

const app = express();

app.get("/", (req, res) => {
	return res.json({
		message: "Welcome to rapid news api!",
		error: false,
	});
});

app.use("/news", newsApi);

const PORT = 5555;

app.listen(PORT, () => {
	console.log(`Listening on Port ${PORT}`);
});
