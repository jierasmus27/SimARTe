import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["backdrop", "panel"];

  connect() {
    this._mq = window.matchMedia("(min-width: 768px)");
    this._onMq = () => this._syncDesktop();
    this._mq.addEventListener("change", this._onMq);
    this._syncDesktop();
  }

  disconnect() {
    this._mq.removeEventListener("change", this._onMq);
  }

  open() {
    if (this._mq.matches) return;
    this.panelTarget.classList.remove("-translate-x-full");
    this.backdropTarget.classList.remove("hidden");
  }

  close() {
    if (this._mq.matches) return;
    this.panelTarget.classList.add("-translate-x-full");
    this.backdropTarget.classList.add("hidden");
  }

  _syncDesktop() {
    if (this._mq.matches) {
      this.panelTarget.classList.remove("-translate-x-full");
      this.backdropTarget.classList.add("hidden");
    } else {
      this.panelTarget.classList.add("-translate-x-full");
      this.backdropTarget.classList.add("hidden");
    }
  }
}
