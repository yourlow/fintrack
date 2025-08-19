// app/javascript/controllers/shortcut_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { transactionId: Number };

  connect() {
    // Listen at the document level
    this.boundHandler = this.handleShortcut.bind(this);
    document.addEventListener("keydown", this.boundHandler);
  }

  disconnect() {
    // Clean up so you don't leak handlers
    document.removeEventListener("keydown", this.boundHandler);
  }

  handleShortcut(event) {
    if (event.ctrlKey && event.key === "1") {
      event.preventDefault();

      const formData = new FormData(this.element);
      formData.delete("_method"); // remove the hidden patch override

      const transaction = {};
      formData.forEach((value, key) => {
        const match = key.match(/^transaction\[(.+)\]$/);
        if (match) {
          transaction[match[1]] = value;
        }
      });

      transaction.entries_attributes = {
        0: { account_id: 1, entry_type: "debit", amount: 100 },
        1: { account_id: 2, entry_type: "credit", amount: 100 },
      };

      const payload = { transaction };
      const token = document.querySelector("meta[name=csrf-token]").content;

      fetch(`/transactions/${this.transactionIdValue}/shortcut`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token,
        },
        body: JSON.stringify(payload),
      });
    }
  }
}
