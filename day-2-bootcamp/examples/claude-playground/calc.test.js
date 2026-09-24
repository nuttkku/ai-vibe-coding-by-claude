import { test } from 'node:test';
import assert from 'node:assert/strict';
import { total, average, applyDiscount, formatBaht } from './calc.js';

test('total adds every price', () => {
  assert.equal(total([100, 200, 300]), 600);
});

test('average of prices', () => {
  assert.equal(average([100, 200, 300]), 200);
});

test('average of an empty list is 0', () => {
  assert.equal(average([]), 0);
});

test('applyDiscount takes a percentage like 10 for 10%', () => {
  assert.equal(applyDiscount(200, 10), 180);
});

test('formatBaht shows two decimals', () => {
  assert.equal(formatBaht(1234.5), '1234.50 บาท');
});
