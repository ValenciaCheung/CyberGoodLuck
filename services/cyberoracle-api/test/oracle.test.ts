import test from "node:test";
import assert from "node:assert/strict";
import { loadFortuneLevelsConfig } from "../src/config.js";
import { decideYesNo, drawFortune, generateDailyLuck } from "../src/oracle.js";

test("daily luck is deterministic for same date", () => {
  const date = new Date("2025-01-01T12:34:56.000Z");
  const a = generateDailyLuck(date);
  const b = generateDailyLuck(date);
  assert.deepEqual(a, b);
});

test("fortune draw returns configured key", async () => {
  const config = await loadFortuneLevelsConfig();
  const date = new Date("2025-01-01T12:34:56.000Z");
  const draw = drawFortune(config, date);
  const keys = new Set(config.levels.map(l => l.key));
  assert.equal(keys.has(draw.level.key), true);
});

test("decision is deterministic for same question and date", () => {
  const date = new Date("2025-01-01T12:34:56.000Z");
  const a = decideYesNo("吃什么", date);
  const b = decideYesNo("吃什么", date);
  assert.deepEqual(a, b);
});

