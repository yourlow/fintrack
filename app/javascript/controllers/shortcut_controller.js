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

    shorcuts.forEach((shortcut) => {});

    if (event.ctrlKey && event.key === "Enter") {
      event.preventDefault();
      this.element.requestSubmit(); // submits the form
      return;
    }

    if (event.ctrlKey && event.key === "1") {
      event.preventDefault();

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

  // function shortcut_key_decoder() {

  // }

  process_shortcut = (element, shortcuts) => {
    const formData = new FormData(element);
    formData.delete("_method");

    // Convert form data into nested JSON
    const transaction = {};
    formData.forEach((value, key) => {
      const match = key.match(/^transaction\[(.+)\]$/);
      if (match) {
        transaction[match[1]] = value;
      }
    });

    let amount = Math.abs(transaction.amount);
    if (isNaN(amount)) amount = 0;

    // Add shortcut-generated entries
    transaction.entries_attributes = {
      0: { account_id: 2, entry_type: "debit", amount: amount },
      1: { account_id: 1, entry_type: "credit", amount: amount },
    };
  };
}
