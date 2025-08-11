import { Controller } from "@hotwired/stimulus";

// Connect on the <turbo-frame> so lifecycle matches the frame
export default class extends Controller {
  static values = {
    index: Number, // current.computed_index
    frameUrl: String, // e.g. "/transactions/frame"
    frameId: String, // e.g. "transaction_table"
  };

  connect() {
    // Use AbortController so removing listeners is guaranteed on disconnect
    this.abort = new AbortController();

    // Sync index after each frame load (this controller sits on the frame)
    this.element.addEventListener(
      "turbo:frame-load",
      () => {
        const marker = this.element.querySelector("[data-computed-index]");
        if (marker)
          this.indexValue = parseInt(marker.dataset.computedIndex, 10);
      },
      { signal: this.abort.signal }
    );

    // Global keydown
    document.addEventListener("keydown", (e) => this.onKeydown(e), {
      signal: this.abort.signal,
    });
  }

  disconnect() {
    // Automatically removes all listeners added with this.abort.signal
    this.abort.abort();
  }

  onKeydown(event) {
    // Don’t hijack typing
    const t = event.target;
    if (t.closest("input, textarea, [contenteditable]")) return;

    if (event.key === "ArrowLeft") {
      event.preventDefault();
      this.goto(this.indexValue - 1);
    } else if (event.key === "ArrowRight") {
      event.preventDefault();
      this.goto(this.indexValue + 1);
    }
  }

  goto(index) {
    this.indexValue = index;
    Turbo.visit(`${this.frameUrlValue}?curr=${index}`, {
      frame: this.frameIdValue,
    });
  }
}
