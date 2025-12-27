import { SplitMix64, daySeed, combineSeeds, stringSeed } from "./determinism.js";
export function generateDailyLuck(date) {
    const seed = daySeed(date);
    const rng = new SplitMix64(seed);
    const metrics = {
        LOVE: sampleTier(rng),
        MONEY: sampleTier(rng),
        CAREER: sampleTier(rng),
        HEALTH: sampleTier(rng)
    };
    const day = isoDay(date);
    return { date: day, metrics };
}
export function drawFortune(config, at) {
    const seed = daySeed(at);
    const rng = new SplitMix64(seed);
    const level = pickLevel(config.levels, rng);
    const copy = pickCopy(level, rng);
    return { drawnAt: at.toISOString(), level, copy };
}
export function decideYesNo(question, at) {
    const s = combineSeeds(daySeed(at), stringSeed(question ?? ""));
    const rng = new SplitMix64(s);
    const result = rng.nextUnitInterval() < 0.5 ? "YES" : "NO";
    return { decidedAt: at.toISOString(), question, result };
}
function sampleTier(rng) {
    const u = approximateNormal01(rng);
    if (u >= 1.15)
        return 1;
    if (u >= 0.05)
        return 2;
    if (u >= -1.15)
        return 3;
    return 4;
}
function approximateNormal01(rng) {
    let sum = 0;
    for (let i = 0; i < 12; i++)
        sum += rng.nextUnitInterval();
    return sum - 6;
}
function pickLevel(levels, rng) {
    const roll = rng.nextUnitInterval();
    let cumulative = 0;
    for (const level of levels) {
        cumulative += level.probability;
        if (roll <= cumulative)
            return level;
    }
    return levels[levels.length - 1];
}
function pickCopy(level, rng) {
    const examples = level.copy_examples ?? [];
    if (examples.length === 0)
        return "";
    const idx = Math.floor(rng.nextUnitInterval() * examples.length);
    return examples[Math.max(0, Math.min(idx, examples.length - 1))] ?? "";
}
function isoDay(date) {
    const y = date.getFullYear();
    const m = String(date.getMonth() + 1).padStart(2, "0");
    const d = String(date.getDate()).padStart(2, "0");
    return `${y}-${m}-${d}`;
}
