export type EntryType = "credit" | "debit";

export type TransactionEntry = {
  account: string;
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
  account: string;
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
