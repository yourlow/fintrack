// app/javascript/controllers/shortcut_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { transactionId: Number };

  connect() {
    this.boundHandleShortcut = this.handleShortcut.bind(this);
    document.addEventListener("keydown", this.boundHandleShortcut);
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundHandleShortcut);
  }

  handleShortcut = (event) => {
    // Ctrl+1
    if (event.ctrlKey && event.key === "1") {
      event.preventDefault();

      const formData = new FormData(this.element);
      formData.delete("_method"); // remove the hidden patch override

      // Convert form data into nested JSON
      const transaction = {};
      formData.forEach((value, key) => {
        const match = key.match(/^transaction\[(.+)\]$/);
        if (match) {
          transaction[match[1]] = value;
        }
      });

      // Add shortcut-generated entries here:
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
          Accept: "text/vnd.turbo-stream.html",
        },
        body: JSON.stringify(payload),
      })
        .then((r) => r.text())
        .then((html) => Turbo.renderStreamMessage(html));
    }
  };
}
