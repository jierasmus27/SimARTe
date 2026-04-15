import { Controller } from "@hotwired/stimulus";

/**
 * Submit subscription forms only when the checkbox moves in the intended direction:
 * - create form: submit when checked (subscribe)
 * - destroy form: submit when unchecked (unsubscribe)
 */
export default class extends Controller {
  submitIfChecked(event) {
    const input = event.currentTarget;
    if (input.checked) {
      input.closest("form").requestSubmit();
    }
  }

  submitIfUnchecked(event) {
    const input = event.currentTarget;
    if (!input.checked) {
      input.closest("form").requestSubmit();
    }
  }
}
