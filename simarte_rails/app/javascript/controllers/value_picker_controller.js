import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["hiddenInput", "label"];

  select(event) {
    event.stopPropagation();
    const value = event.currentTarget.dataset.optionValue;
    if (this.hasHiddenInputTarget) {
      this.hiddenInputTarget.value = value;
    }
    if (this.hasLabelTarget) {
      const labelText = event.currentTarget.dataset.optionLabel ?? value;
      this.labelTarget.textContent = labelText;
    }
    this.element.dispatchEvent(new Event("change", { bubbles: true }));
    this.dispatch("selected", {
      detail: { value },
      prefix: false
    });
  }
}
