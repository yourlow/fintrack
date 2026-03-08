import type { Transaction } from "./types";
import { formatCurrency } from "./utils";

type Props = {
  transactions: Transaction[];
  currentId?: number;
  onDelete?: (id: number) => void;
  deletingId?: number | undefined;
  isDeleting?: boolean;
};

export function TransactionTable({
  transactions,
  currentId,
  onDelete,
  deletingId,
  isDeleting,
}: Props) {
  return (
    <div className="overflow-x-auto">
      <table className="table table-zebra table-sm w-full">
        <thead>
          <tr>
            <th scope="col"></th>
            <th scope="col">ID</th>
            <th scope="col">Date</th>
            <th scope="col">Raw Description</th>
            <th scope="col">User Description</th>
            <th scope="col">Amount</th>
            <th scope="col">Balanced</th>
            <th scope="col">Actions</th>
          </tr>
        </thead>
        <tbody>
          {transactions.map((transaction) => (
            <tr
              key={transaction.id}
              className={
                currentId === transaction.id ? "bg-primary/10 font-semibold" : ""
              }
            >
              <td>{currentId === transaction.id ? "➜" : ""}</td>
              <td>{transaction.id}</td>
              <td>{transaction.transaction_date}</td>
              <td>{transaction.raw_description}</td>
              <td>{transaction.user_description}</td>
              <td>{formatCurrency(transaction.amount)}</td>
              <td>
                {transaction.balanced ? "true" : "false"},{" "}
                {formatCurrency(
                  transaction.entries.reduce(
                    (sum, entry) => sum + entry.amount,
                    0,
                  ),
                )}
                , {transaction.amount}
              </td>
              <td>
                <button
                  className="btn btn-error btn-sm"
                  type="button"
                  onClick={() => onDelete?.(transaction.id)}
                  disabled={isDeleting || deletingId === transaction.id}
                >
                  {deletingId === transaction.id ? "Deleting..." : "Delete"}
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
