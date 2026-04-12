import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["background", "content", "selectedLabel", "selectedValue"]

  open(event) {
    event.stopPropagation()
    this.backgroundTarget.classList.remove("hidden")
  }

  close(event) {
    if (!this.contentTarget.contains(event.target)) {
      event.stopPropagation()
      this.backgroundTarget.classList.add("hidden")
    }
  }

  selectOption(event) {
    event.stopPropagation()
    const value = event.currentTarget.dataset.optionValue
    this.selectedLabelTarget.textContent = value
    this.selectedValueTarget.value = value
    this.backgroundTarget.classList.add("hidden")
    this.element.dispatchEvent(new Event("change", { bubbles: true }))
    this.dispatch("selected", {
      detail: { value },
      prefix: false
    })
  }
}
