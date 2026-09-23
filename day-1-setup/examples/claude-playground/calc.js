// Small helpers for a shop's daily sales report.
// This file contains intentional bugs for the Day 1 Claude Code bootcamp. Do not "fix" them in the course repo.

export function total(prices) {
  let sum = 0;
  for (let i = 1; i < prices.length; i++) {
    sum += prices[i];
  }
  return sum;
}

export function average(prices) {
  return total(prices) / prices.length;
}

export function applyDiscount(price, percent) {
  return price - price * percent;
}

export function formatBaht(amount) {
  return amount.toFixed(2) + ' บาท';
}
