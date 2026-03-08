import type { Account, EntryForm, EntryType } from "./types";
import { formatCurrency } from "./utils";

type Props = {
  entries: EntryForm[];
  accounts: Account[];
  totals: { creditCents: number; debitCents: number };
  onChange: (id: number, field: keyof EntryForm, value: string) => void;
  onRemove: (id: number) => void;
  onAdd: () => void;
};

export function EntriesTable({
  entries,
  accounts,
  totals,
  onChange,
  onRemove,
  onAdd,
}: Props) {
  return (
    <div>
      <table className="table table-zebra w-full" id="entries">
        <thead>
          <tr>
            <th>Account</th>
            <th>Type (Credit/Debit)</th>
            <th>Credit</th>
            <th>Debit</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {entries.map((entry) => (
            <tr key={entry.id}>
              <td>
                <select
                  className="select select-bordered w-full"
                  value={entry.accountId}
                  onChange={(e) => onChange(entry.id, "accountId", e.target.value)}
                >
                  <option value="">Select</option>
                  {accounts.map((account) => (
                    <option key={account.id} value={account.id}>
                      {account.name}
                    </option>
                  ))}
                </select>
              </td>
              <td>
                <select
                  className="select select-bordered w-full"
                  value={entry.entry_type}
                  onChange={(e) =>
                    onChange(
                      entry.id,
                      "entry_type",
                      e.target.value as EntryType,
                    )
                  }
                >
                  <option value="">Choose type</option>
                  <option value="credit">Credit</option>
                  <option value="debit">Debit</option>
                </select>
              </td>
              <td>
                <input
                  type="number"
                  className="input input-bordered w-full"
                  value={entry.credit_amount}
                  disabled={entry.entry_type !== "credit"}
                  onChange={(e) =>
                    onChange(entry.id, "credit_amount", e.target.value)
                  }
                />
              </td>
              <td>
                <input
                  type="number"
                  className="input input-bordered w-full"
                  value={entry.debit_amount}
                  disabled={entry.entry_type !== "debit"}
                  onChange={(e) =>
                    onChange(entry.id, "debit_amount", e.target.value)
                  }
                />
              </td>
              <td>
                <button
                  type="button"
                  className="btn btn-error btn-sm"
                  onClick={() => onRemove(entry.id)}
                >
                  Remove Entry
                </button>
              </td>
            </tr>
          ))}
          <tr>
            <td></td>
            <td></td>
            <td>{formatCurrency(-totals.creditCents)}</td>
            <td>{formatCurrency(totals.debitCents)}</td>
            <td></td>
          </tr>
        </tbody>
      </table>
      <div className="flex justify-center mt-4">
        <button type="button" className="btn btn-secondary" onClick={onAdd}>
          Add Entry
        </button>
      </div>
    </div>
  );
}
