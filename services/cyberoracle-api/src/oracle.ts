import type { FortuneLevel, FortuneLevelsConfig } from "./config.js";
import { SplitMix64, daySeed, combineSeeds, stringSeed } from "./determinism.js";

export type DailyLuckMetric = "LOVE" | "MONEY" | "CAREER" | "HEALTH";
export type DailyLuckTier = 1 | 2 | 3 | 4;

export type DailyLuck = {
  date: string;
  metrics: Record<DailyLuckMetric, DailyLuckTier>;
};

export type FortuneDraw = {
  drawnAt: string;
  level: FortuneLevel;
  copy: string;
};

export type DecisionResult = {
  decidedAt: string;
  question?: string;
  result: "YES" | "NO";
};

export function generateDailyLuck(date: Date): DailyLuck {
  const seed = daySeed(date);
  const rng = new SplitMix64(seed);

  const metrics: DailyLuck["metrics"] = {
    LOVE: sampleTier(rng),
    MONEY: sampleTier(rng),
    CAREER: sampleTier(rng),
    HEALTH: sampleTier(rng)
  };

  const day = isoDay(date);
  return { date: day, metrics };
}

export function drawFortune(config: FortuneLevelsConfig, at: Date): FortuneDraw {
  const seed = daySeed(at);
  const rng = new SplitMix64(seed);
  const level = pickLevel(config.levels, rng);
  const copy = pickCopy(level, rng);
  return { drawnAt: at.toISOString(), level, copy };
}

export function decideYesNo(question: string | undefined, at: Date): DecisionResult {
  const s = combineSeeds(daySeed(at), stringSeed(question ?? ""));
  const rng = new SplitMix64(s);
  const result = rng.nextUnitInterval() < 0.5 ? "YES" : "NO";
  return { decidedAt: at.toISOString(), question, result };
}

function sampleTier(rng: SplitMix64): DailyLuckTier {
  const u = approximateNormal01(rng);

  if (u >= 1.15) return 1;
  if (u >= 0.05) return 2;
  if (u >= -1.15) return 3;
  return 4;
}

function approximateNormal01(rng: SplitMix64): number {
  let sum = 0;
  for (let i = 0; i < 12; i++) sum += rng.nextUnitInterval();
  return sum - 6;
}

function pickLevel(levels: FortuneLevel[], rng: SplitMix64): FortuneLevel {
  const roll = rng.nextUnitInterval();
  let cumulative = 0;
  for (const level of levels) {
    cumulative += level.probability;
    if (roll <= cumulative) return level;
  }
  return levels[levels.length - 1];
}

function pickCopy(level: FortuneLevel, rng: SplitMix64): string {
  const examples = level.copy_examples ?? [];
  if (examples.length === 0) return "";
  const idx = Math.floor(rng.nextUnitInterval() * examples.length);
  return examples[Math.max(0, Math.min(idx, examples.length - 1))] ?? "";
}

function isoDay(date: Date): string {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, "0");
  const d = String(date.getDate()).padStart(2, "0");
  return `${y}-${m}-${d}`;
}

