import Fastify from "fastify";
import cors from "@fastify/cors";
import { loadFortuneLevelsConfig } from "./config.js";
import { decideYesNo, drawFortune, generateDailyLuck } from "./oracle.js";
export async function buildServer() {
    const app = Fastify({ logger: true });
    await app.register(cors, { origin: true });
    const config = await loadFortuneLevelsConfig();
    app.get("/health", async () => ({ ok: true }));
    app.get("/v1/config/fortune-levels", async () => config);
    app.get("/v1/daily-luck", async (req, reply) => {
        const dateParam = req.query.date;
        const date = dateParam ? new Date(`${dateParam}T00:00:00.000Z`) : new Date();
        if (Number.isNaN(date.getTime()))
            return reply.code(400).send({ error: "Invalid date" });
        return generateDailyLuck(date);
    });
    app.post("/v1/fortune/draw", async (req, reply) => {
        const at = req.body?.at ? new Date(req.body.at) : new Date();
        if (Number.isNaN(at.getTime()))
            return reply.code(400).send({ error: "Invalid at" });
        return drawFortune(config, at);
    });
    app.post("/v1/decision/yesno", async (req, reply) => {
        const at = req.body?.at ? new Date(req.body.at) : new Date();
        if (Number.isNaN(at.getTime()))
            return reply.code(400).send({ error: "Invalid at" });
        return decideYesNo(req.body?.question, at);
    });
    return app;
}
