import axios from "axios";
import { API_KEY } from "../../Secret/api-key.js";

export async function fetchAll(req, res) {
	try {
		const { searchKey, category, pageNo, sortBy } = req.body;

		let query = `https://newsapi.org/v2/top-headlines?country=us&apiKey=${API_KEY}`;
		if (searchKey) {
			query += `&q=${searchKey}`;
		}
		if (category) {
			query += `&category=${category}`;
		}
		if (pageNo) {
			query += `&page=${pageNo}`;
		}
		if (sortBy) {
			query += `&sortBy=${sortBy}`;
		}
		console.log(query);

		const apiRes = await axios.get(query);

		return res.json({
			data: apiRes.data,
			message: "Fetched all news.",
			error: false,
		});
	} catch (error) {
		return res.json({
			message: `${error}`,
			error: true,
		});
	}
}
