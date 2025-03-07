import axios from "axios";
import { API_KEY } from "../../Secret/api-key.js";

export async function fetchTrending(req, res) {
	try {
		const apiRes = await axios.get(
			`https://newsapi.org/v2/top-headlines?country=us&apiKey=${API_KEY}`
		);

		return res.json({
			data: apiRes.data,
			message: "Fetched trending news.",
			error: false,
		});
	} catch (error) {
		return res.json({
			message: `${error}`,
			error: true,
		});
	}
}
