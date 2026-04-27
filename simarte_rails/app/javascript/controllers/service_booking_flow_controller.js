import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["calendar"];

  showCalendar() {
    this.calendarTarget.classList.remove("hidden");
  }
}
