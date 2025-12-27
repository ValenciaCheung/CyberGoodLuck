import { readFile } from "node:fs/promises";
import { resolve } from "node:path";
export async function loadFortuneLevelsConfig() {
    const filePath = resolve(process.cwd(), "../../config/fortune_levels.json");
    const raw = await readFile(filePath, "utf8");
    const parsed = JSON.parse(raw);
    const sum = parsed.levels.reduce((acc, l) => acc + l.probability, 0);
    if (Math.abs(sum - 1) > 0.0001) {
        throw new Error("Invalid fortune level probabilities: must sum to 1.0");
    }
    return parsed;
}
