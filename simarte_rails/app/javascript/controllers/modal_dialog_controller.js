import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["background", "content"]

  open(event) {
    event.stopPropagation()
    this.backgroundTarget.classList.remove("hidden")
  }

  dismissBackground(event) {
    if (!this.contentTarget.contains(event.target)) {
      this.dismiss(event)
    }
  }

  dismiss(event) {
    event.stopPropagation()
    this.backgroundTarget.classList.add("hidden")
  }
}
