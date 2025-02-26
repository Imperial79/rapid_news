import express from "express";
import newsApi from "./api-routes/news/index.js";
import bodyParser from "body-parser";

const app = express();

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
app.use(bodyParser.json());

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
