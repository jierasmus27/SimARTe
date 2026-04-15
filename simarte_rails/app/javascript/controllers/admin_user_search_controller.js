import { Controller } from "@hotwired/stimulus";

const FOCUS_KEY = "admin-user-search:focus";

/** Debounced GET form submit for admin user list search. Restores focus + cursor after Turbo re-render. */
export default class extends Controller {
  static targets = ["input"];
  static values  = { delay: { type: Number, default: 300 } };

  connect() {
    this.timeout = null;

    if (sessionStorage.getItem(FOCUS_KEY)) {
      sessionStorage.removeItem(FOCUS_KEY);
      this.restoreFocus();
    }
  }

  disconnect() {
    if (this.timeout) clearTimeout(this.timeout);
  }

  scheduleSubmit() {
    if (this.timeout) clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.timeout = null;
      sessionStorage.setItem(FOCUS_KEY, "1");
      this.element.requestSubmit();
    }, this.delayValue);
  }

  restoreFocus() {
    if (!this.hasInputTarget) return;
    const input = this.inputTarget;
    requestAnimationFrame(() => {
      input.focus();
      const len = input.value.length;
      input.setSelectionRange(len, len);
    });
  }
}
