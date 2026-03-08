import type { Transaction } from "./types";

export const fakeTransactions: Transaction[] = [
  {
    id: 1001,
    transaction_date: "2024-05-10",
    raw_description: "STARBUCKS 1234",
    user_description: "Coffee with team",
    amount: -1450,
    balanced: true,
    entries: [
      { account: "Cash", entry_type: "credit", amount: -1450 },
      { account: "Dining", entry_type: "debit", amount: 1450 },
    ],
  },
  {
    id: 1002,
    transaction_date: "2024-05-11",
    raw_description: "PAYROLL DIRECT DEPOSIT",
    user_description: "Paycheck",
    amount: 225000,
    balanced: true,
    entries: [
      { account: "Income", entry_type: "credit", amount: -225000 },
      { account: "Checking", entry_type: "debit", amount: 225000 },
    ],
  },
  {
    id: 1003,
    transaction_date: "2024-05-12",
    raw_description: "UBER TRIP 9876",
    user_description: "Airport ride",
    amount: -3299,
    balanced: false,
    entries: [
      { account: "Cash", entry_type: "credit", amount: -3299 },
      { account: "Travel", entry_type: "debit", amount: 2800 },
    ],
  },
];

export const fakeAccounts = [
  "Cash",
  "Checking",
  "Savings",
  "Dining",
  "Travel",
  "Income",
];
