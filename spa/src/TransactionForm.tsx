import type { FormEvent } from "react";
import { EntriesTable } from "./EntriesTable";
import type { Account, EntryForm, TransactionFormState } from "./types";

type Props = {
  accounts: Account[];
  formState: TransactionFormState;
  entries: EntryForm[];
  totals: { creditCents: number; debitCents: number };
  onFormChange: (field: keyof TransactionFormState, value: string) => void;
  onEntryChange: (id: number, field: keyof EntryForm, value: string) => void;
  onAddEntry: () => void;
  onRemoveEntry: (id: number) => void;
  onSubmit: (e: FormEvent) => void;
  isSaving?: boolean;
};

export function TransactionForm({
  accounts,
  formState,
  entries,
  totals,
  onFormChange,
  onEntryChange,
  onAddEntry,
  onRemoveEntry,
  onSubmit,
  isSaving,
}: Props) {
  return (
    <div className="w-full rounded-box bg-base-100 p-6 shadow-sm">
      <form className="space-y-4" onSubmit={onSubmit}>
        <div className="flex flex-wrap gap-6">
          <div className="w-full md:w-7/12 space-y-4 min-w-[300px]">
            <div>
              <label className="block mb-1">Raw description</label>
              <input
                className="input input-bordered w-full"
                value={formState.raw_description}
                onChange={(e) => onFormChange("raw_description", e.target.value)}
              />
            </div>
            <div>
              <label className="block mb-1">User description</label>
              <input
                className="input input-bordered w-full"
                value={formState.user_description}
                onChange={(e) =>
                  onFormChange("user_description", e.target.value)
                }
              />
            </div>
            <div>
              <label className="block mb-1">Amount</label>
              <input
                type="number"
                className="input input-bordered w-full"
                value={formState.amount}
                onChange={(e) => onFormChange("amount", e.target.value)}
              />
            </div>
            <div>
              <label className="block mb-1">Transaction date</label>
              <input
                type="date"
                className="input input-bordered w-full"
                value={formState.transaction_date}
                onChange={(e) =>
                  onFormChange("transaction_date", e.target.value)
                }
              />
            </div>
            <button className="btn btn-primary" type="submit" disabled={isSaving}>
              {isSaving ? "Saving..." : "Save transaction"}
            </button>
          </div>

          <div className="w-full md:w-5/12 min-w-[280px]">
            <EntriesTable
              accounts={accounts}
              entries={entries}
              totals={totals}
              onAdd={onAddEntry}
              onRemove={onRemoveEntry}
              onChange={onEntryChange}
            />
          </div>
        </div>
      </form>
    </div>
  );
}
