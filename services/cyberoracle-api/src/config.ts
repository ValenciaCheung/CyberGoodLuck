import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

export type FortuneLevelKey = "ULTRA" | "SUPER" | "BASIC" | "GLITCH" | "ERROR";

export type FortuneLevel = {
  key: FortuneLevelKey;
  label: string;
  emoji: string;
  probability: number;
  color: string;
  style: string;
  copy_examples: string[];
  haptics: string;
  humorize?: boolean;
};

export type FortuneLevelsConfig = {
  version: string;
  locale: string;
  levels: FortuneLevel[];
  distribution_note?: string;
  themes?: unknown;
};

export async function loadFortuneLevelsConfig(): Promise<FortuneLevelsConfig> {
  const filePath = resolve(process.cwd(), "../../config/fortune_levels.json");
  const raw = await readFile(filePath, "utf8");
  const parsed = JSON.parse(raw) as FortuneLevelsConfig;

  const sum = parsed.levels.reduce((acc, l) => acc + l.probability, 0);
  if (Math.abs(sum - 1) > 0.0001) {
    throw new Error("Invalid fortune level probabilities: must sum to 1.0");
  }
  return parsed;
}

