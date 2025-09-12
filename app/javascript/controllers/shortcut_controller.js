// app/javascript/controllers/shortcut_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { transactionId: Number };

  connect() {
    // Parse shortcuts from DOM
    this.shortcuts = JSON.parse(
      document.getElementById("shortcuts-data").textContent
    );

    this.handlers = [];

    // Special hardcoded Ctrl+Enter for submitting the form
    const submitHandler = (event) => {
      if (event.ctrlKey && event.key === "Enter") {
        event.preventDefault();
        this.element.requestSubmit();
      }
    };
    document.addEventListener("keydown", submitHandler);
    this.handlers.push(submitHandler);

    // JSON-driven shortcuts
    this.shortcuts.forEach((shortcut) => {
      const actions = this.decodeShortcuts(shortcut.combination);

      const handler = (event) => {
        if (actions.every((fn) => fn(event))) {
          event.preventDefault();

          const payload = {
            transaction: processShortcut(this.element, shortcut),
          };

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

      document.addEventListener("keydown", handler);
      this.handlers.push(handler);
    });
  }

  disconnect() {
    this.handlers.forEach((handler) => {
      document.removeEventListener("keydown", handler);
    });
    this.handlers = [];
  }

  decodeShortcuts(keyString) {
    const keys = keyString.split("+");
    return keys.map((key) => {
      if (key === "Ctrl") {
        return (event) => event.ctrlKey;
      } else {
        return (event) => event.key === key;
      }
    });
  }
}

// helper function
function processShortcut(element, shortcut) {
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

  let credit_amount = Math.abs(transaction.credit_amount);
  if (isNaN(amount)) amount = 0;

  transaction.entries_attributes = {};

  shortcut.shortcut_entries.forEach((entry, idx) => {
    transaction.entries_attributes[idx] = {
      account_id: entry.account_id,
      entry_type: entry.entry_type,
      amount: amount,
    };
  });

  return transaction;
}
