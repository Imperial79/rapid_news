import { Router } from "express";
import { fetchAll } from "./fetch-all.js";

const newsApi = Router();

newsApi.get("/fetch", fetchAll);

export default newsApi;
