const express = require("express");

const app = express();

app.get("/", (req, res) => {
	return res.json({
		message: "Welcome to rapid news api!",
		error: false,
	});
});

const PORT = 5555;

app.listen(PORT, () => {
	console.log(`Listening on Port ${PORT}`);
});
