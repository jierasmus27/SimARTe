import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["submit"];

  openSubmit(event) {
    event.stopPropagation();
    this.submitTarget.classList.remove("hidden");
  }

  closeSubmit(event) {
    event.stopPropagation();
    this.submitTarget.classList.add("hidden");
  }
}
