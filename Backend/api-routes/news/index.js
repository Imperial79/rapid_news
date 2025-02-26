import { Router } from "express";
import { fetchAll } from "./fetch-all.js";
import { fetchTrending } from "./fetch-trending.js";

const newsApi = Router();

newsApi.post("/fetch", fetchAll);
newsApi.get("/fetch-trending", fetchTrending);

export default newsApi;
