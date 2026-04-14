import { describe, it, expect, beforeEach, afterEach, vi } from "vitest"
import ValuePickerController from "../../../app/javascript/controllers/value_picker_controller.js"
import ModalDialogController from "../../../app/javascript/controllers/modal_dialog_controller.js"
import { getController, startStimulus } from "../helpers/stimulus_test_helpers.js"

describe("value_picker_controller", () => {
  let application

  beforeEach(() => {
    application = startStimulus({
      "value-picker": ValuePickerController,
      "modal-dialog": ModalDialogController
    })
    document.body.innerHTML = `
      <div data-controller="value-picker">
        <div data-controller="modal-dialog">
          <button type="button" data-action="click->modal-dialog#open">Open</button>
          <div class="hidden" data-modal-dialog-target="background" data-action="click->modal-dialog#dismissBackground">
            <div data-modal-dialog-target="content">
              <input type="hidden" data-value-picker-target="hiddenInput" name="user[role]" value="user" />
              <div
                data-action="click->value-picker#select click->modal-dialog#dismiss"
                data-option-value="admin"
              >
                Admin
              </div>
            </div>
          </div>
          <span data-value-picker-target="label">User</span>
        </div>
      </div>
    `
  })

  afterEach(() => {
    application.stop()
    document.body.innerHTML = ""
  })

  it("select updates hidden field and label, dispatches selected, and dismiss closes modal", () => {
    const root = document.querySelector("[data-controller='value-picker']")
    const background = document.querySelector("[data-modal-dialog-target='background']")
    const hidden = document.querySelector("[data-value-picker-target='hiddenInput']")
    const label = document.querySelector("[data-value-picker-target='label']")
    const optionRow = document.querySelector("[data-option-value='admin']")
    const picker = getController(application, root, "value-picker")
    const modalDialog = getController(
      application,
      document.querySelector("[data-controller='modal-dialog']"),
      "modal-dialog"
    )

    modalDialog.open({ stopPropagation: () => {} })
    expect(background.classList.contains("hidden")).toBe(false)

    const dispatchSpy = vi.spyOn(picker, "dispatch")
    const changeSpy = vi.spyOn(root, "dispatchEvent")

    optionRow.click()

    expect(hidden.value).toBe("admin")
    expect(label.textContent).toBe("admin")
    expect(background.classList.contains("hidden")).toBe(true)

    expect(dispatchSpy).toHaveBeenCalledWith(
      "selected",
      expect.objectContaining({
        detail: { value: "admin" },
        prefix: false
      })
    )

    expect(changeSpy).toHaveBeenCalled()
    dispatchSpy.mockRestore()
    changeSpy.mockRestore()
  })
})
