import axios from "axios";
import type { EntryForm, TransactionFormState, TransactionsIndexResponse } from "./types";

const csrfToken =
  document.querySelector('meta[name="csrf-token"]')?.getAttribute("content") || "";

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || "",
  headers: {
    Accept: "application/json",
    "X-CSRF-Token": csrfToken,
  },
  withCredentials: true,
});

export const fetchTransactions = async (curr?: number | string) => {
  const response = await api.get<TransactionsIndexResponse>("/transactions.json", {
    params: curr ? { curr } : undefined,
  });
  return response.data;
};

export const client = api;

export const updateTransaction = async (
  id: number,
  form: TransactionFormState,
  entries: EntryForm[],
) => {
  const entriesAttributes = entries
    .filter((e) => e.entry_type && e.accountId)
    .map((e) => ({
      id: e.id,
      account_id: e.accountId,
      entry_type: e.entry_type,
      debit_amount: e.entry_type === "debit" ? e.debit_amount : "",
      credit_amount: e.entry_type === "credit" ? e.credit_amount : "",
    }));

  const payload = {
    transaction: {
      raw_description: form.raw_description,
      user_description: form.user_description,
      amount: form.amount,
      transaction_date: form.transaction_date,
      entries_attributes: entriesAttributes,
    },
  };

  const response = await api.patch(`/transactions/${id}.json`, payload);
  return response.data;
};

export const deleteTransaction = async (id: number) => {
  await api.delete(`/transactions/${id}.json`);
};
