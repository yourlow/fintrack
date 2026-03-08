// app/javascript/controllers/entry_type_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["select", "creditAmount", "debitAmount"];

  connect() {
    console.log("entry-type controller connected");
    this.toggleInputs();
  }

  change() {
    console.log("entry-type change fired", this.selectTarget.value);
    this.creditAmountTarget.value = "";
    this.debitAmountTarget.value = "";
    this.toggleInputs();
  }

  toggleInputs() {
    if (this.selectTarget.value === "credit") {
      this.creditAmountTarget.disabled = false;
      this.creditAmountTarget.parentElement.style.display = "";

      this.debitAmountTarget.disabled = true;
      this.debitAmountTarget.parentElement.style.display = "disabled";
    } else if (this.selectTarget.value === "debit") {
      this.debitAmountTarget.disabled = false;
      this.debitAmountTarget.parentElement.style.display = "";

      this.creditAmountTarget.disabled = true;
      this.creditAmountTarget.parentElement.style.display = "disabled";
    } else {
      this.creditAmountTarget.disabled = true;
      this.debitAmountTarget.disabled = true;
      this.creditAmountTarget.parentElement.style.display = "disabled";
      this.debitAmountTarget.parentElement.style.display = "disabled";
    }
  }
}
