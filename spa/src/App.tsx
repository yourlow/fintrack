import { useMemo, useState } from "react";
import { TransactionForm } from "./TransactionForm";
import { TransactionNav } from "./TransactionNav";
import { TransactionTable } from "./TransactionTable";
import { fakeAccounts, fakeTransactions } from "./fakeData";
import type { EntryForm, TransactionFormState } from "./types";

function App() {
  const [entries, setEntries] = useState<EntryForm[]>([
    {
      id: 1,
      account: "Cash",
      entry_type: "credit",
      credit_amount: "12.50",
      debit_amount: "",
    },
    {
      id: 2,
      account: "Dining",
      entry_type: "debit",
      credit_amount: "",
      debit_amount: "12.50",
    },
  ]);

  const [formState, setFormState] = useState({
    raw_description: "COFFEE SHOP",
    user_description: "Latte and croissant",
    amount: "12.50",
    transaction_date: "2024-05-13",
  } satisfies TransactionFormState);

  const totals = useMemo(() => {
    let creditCents = 0;
    let debitCents = 0;
    entries.forEach((entry) => {
      if (entry.entry_type === "credit" && entry.credit_amount) {
        creditCents += Math.round((parseFloat(entry.credit_amount) || 0) * 100);
      } else if (entry.entry_type === "debit" && entry.debit_amount) {
        debitCents += Math.round((parseFloat(entry.debit_amount) || 0) * 100);
      }
    });
    return { creditCents, debitCents };
  }, [entries]);

  const handleEntryChange = (
    id: number,
    field: keyof EntryForm,
    value: string,
  ) => {
    setEntries((prev) =>
      prev.map((entry) =>
        entry.id === id
          ? {
              ...entry,
              [field]: value,
              credit_amount:
                field === "entry_type" && value === "debit"
                  ? ""
                  : entry.credit_amount,
              debit_amount:
                field === "entry_type" && value === "credit"
                  ? ""
                  : entry.debit_amount,
            }
          : entry,
      ),
    );
  };

  const addEntry = () => {
    const nextId = Math.max(0, ...entries.map((e) => e.id)) + 1;
    setEntries((prev) => [
      ...prev,
      {
        id: nextId,
        account: "",
        entry_type: "",
        credit_amount: "",
        debit_amount: "",
      },
    ]);
  };

  const removeEntry = (id: number) => {
    setEntries((prev) => prev.filter((entry) => entry.id !== id));
  };

  const handleFormChange = (
    field: keyof TransactionFormState,
    value: string,
  ) => {
    setFormState((prev) => ({ ...prev, [field]: value }));
  };

  return (
    <div className="min-h-screen bg-base-200 text-base-content">
      <div className="mx-auto max-w-6xl px-6 py-10 space-y-6">
        <p className="text-green-600">Saved successfully</p>
        <h1 className="text-2xl font-semibold tracking-tight mb-6">
          Transactions
        </h1>

        <TransactionTable transactions={fakeTransactions} />

        <TransactionNav />

        <TransactionForm
          accounts={fakeAccounts}
          formState={formState}
          entries={entries}
          totals={totals}
          onFormChange={handleFormChange}
          onEntryChange={handleEntryChange}
          onAddEntry={addEntry}
          onRemoveEntry={removeEntry}
        />
      </div>
    </div>
  );
}

export default App;
