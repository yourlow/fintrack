import { useEffect, useMemo, useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { TransactionForm } from "./TransactionForm";
import { TransactionNav } from "./TransactionNav";
import { TransactionTable } from "./TransactionTable";
import { fetchTransactions, deleteTransaction, updateTransaction } from "./api";
import type { EntryForm, TransactionFormState } from "./types";

function App() {
  const [currId, setCurrId] = useState<number | undefined>(undefined);
  const [entries, setEntries] = useState<EntryForm[]>([]);

  const [formState, setFormState] = useState({
    raw_description: "",
    user_description: "",
    amount: "",
    transaction_date: "",
  } satisfies TransactionFormState);

  const { data, isLoading, isError, error } = useQuery({
    queryKey: ["transactions", currId],
    queryFn: () => fetchTransactions(currId),
    staleTime: 30_000,
  });

  const queryClient = useQueryClient();

  const deleteMutation = useMutation({
    mutationFn: (id: number) => deleteTransaction(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["transactions"] });
      if (data?.prev_id) {
        setCurrId(data.prev_id);
      } else if (data?.next_id) {
        setCurrId(data.next_id);
      } else {
        setCurrId(undefined);
      }
    },
  });

  const updateMutation = useMutation({
    mutationFn: () =>
      updateTransaction(
        currentId!,
        formState,
        entries.map((e) => ({
          ...e,
          // keep numbers as strings for API compatibility
          credit_amount: e.credit_amount,
          debit_amount: e.debit_amount,
        })),
      ),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["transactions"] });
    },
  });

  useEffect(() => {
    const current = data?.current;
    if (!current) return;

    if (currId === undefined && current.id) {
      setCurrId(current.id);
    }

    setFormState({
      raw_description: current.raw_description ?? "",
      user_description: current.user_description ?? "",
      amount: (current.amount / 100).toFixed(2),
      transaction_date: current.transaction_date ?? "",
    });

    setEntries(
      current.entries.map((entry, idx) => {
        const isCredit = entry.entry_type === "credit";
        return {
          id: entry.id || idx + 1,
          accountId: entry.account_id ?? "",
          entry_type: entry.entry_type,
          credit_amount: isCredit ? (entry.amount / 100).toFixed(2) : "",
          debit_amount: !isCredit ? (entry.amount / 100).toFixed(2) : "",
        };
      }),
    );
  }, [data?.current]);

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
              [field]:
                field === "accountId"
                  ? value === ""
                    ? ""
                    : Number(value)
                  : value,
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
        accountId: "",
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

  const transactions = data?.transactions ?? [];
  const accounts = data?.accounts ?? [];
  const currentId = data?.current?.id;
  const deletingId =
    (deleteMutation.variables as number | undefined) ?? undefined;

  useEffect(() => {
    const onKeyDown = (e: KeyboardEvent) => {
      if (!data) return;
      if (e.ctrlKey && e.key === ",") {
        if (data.prev_id) {
          e.preventDefault();
          setCurrId(data.prev_id);
        }
      } else if (e.ctrlKey && e.key === ".") {
        if (data.next_id) {
          e.preventDefault();
          setCurrId(data.next_id);
        }
      }
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [data]);

  return (
    <div className="min-h-screen bg-base-200 text-base-content">
      <div className="mx-auto w-full px-8 py-10 space-y-6">
        <p className="text-green-600">Saved successfully</p>
        <h1 className="text-2xl font-semibold tracking-tight mb-6">
          Transactions
        </h1>

        {isLoading && (
          <div className="alert">
            <span>Loading transactions…</span>
          </div>
        )}
        {isError && (
          <div className="alert alert-error">
            <span>
              {error instanceof Error ? error.message : "Error loading"}
            </span>
          </div>
        )}

        <TransactionTable
          transactions={transactions}
          currentId={currentId}
          onDelete={(id) => deleteMutation.mutate(id)}
          deletingId={deletingId}
          isDeleting={deleteMutation.isPending}
        />

        <TransactionNav
          onPrev={() => data?.prev_id && setCurrId(data.prev_id)}
          onNext={() => data?.next_id && setCurrId(data.next_id)}
        />

        <TransactionForm
          accounts={accounts}
          formState={formState}
          entries={entries}
          totals={totals}
          onFormChange={handleFormChange}
          onEntryChange={handleEntryChange}
          onAddEntry={addEntry}
          onRemoveEntry={removeEntry}
          onSubmit={(e) => {
            e.preventDefault();
            if (!currentId) return;
            updateMutation.mutate();
          }}
          isSaving={updateMutation.isPending}
        />
      </div>
    </div>
  );
}

export default App;
