export type EntryType = "credit" | "debit";

export type TransactionEntry = {
  id?: number;
  account_id?: number | null;
  account_name?: string | null;
  account?: string;
  entry_type: EntryType;
  amount: number; // cents
};

export type Transaction = {
  id: number;
  transaction_date: string;
  raw_description: string;
  user_description: string;
  amount: number; // cents
  balanced: boolean;
  entries: TransactionEntry[];
};

export type EntryForm = {
  id: number;
  accountId: number | "";
  entry_type: EntryType | "";
  credit_amount: string;
  debit_amount: string;
};

export type TransactionFormState = {
  raw_description: string;
  user_description: string;
  amount: string;
  transaction_date: string;
};

export type Account = {
  id: number;
  name: string;
};

export type ShortcutEntry = {
  id: number;
  entry_type: EntryType;
  account_id: number;
};

export type Shortcut = {
  id: number;
  name: string;
  combination: string;
  shortcut_entries: ShortcutEntry[];
};

export type TransactionsIndexResponse = {
  current: Transaction | null;
  prev_id?: number | null;
  next_id?: number | null;
  transactions: Transaction[];
  shortcuts: Shortcut[];
  accounts: Account[];
};
