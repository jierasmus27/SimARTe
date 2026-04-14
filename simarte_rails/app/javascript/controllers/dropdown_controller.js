import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
    const open = !this.menuTarget.classList.contains("hidden")
    this._setAria(open)
    document.removeEventListener("click", this._outside)
    if (open) {
      queueMicrotask(() => document.addEventListener("click", this._outside))
    }
  }

  closeMenu(event) {
    event.stopPropagation()
    if (!this.hasMenuTarget) return
    this.menuTarget.classList.add("hidden")
    this._setAria(false)
    document.removeEventListener("click", this._outside)
  }

  connect() {
    this._outside = this._outside.bind(this)
  }

  disconnect() {
    document.removeEventListener("click", this._outside)
  }

  _outside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
      this._setAria(false)
      document.removeEventListener("click", this._outside)
    }
  }

  _setAria(open) {
    const btn = this.element.querySelector("button[aria-expanded]")
    if (btn) btn.setAttribute("aria-expanded", open ? "true" : "false")
  }
}
