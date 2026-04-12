import { describe, it, expect, beforeEach, afterEach, vi } from "vitest"
import SelectModalController from "../../../app/javascript/controllers/select_modal_controller.js"
import { getController, startStimulus } from "../helpers/stimulus_test_helpers.js"

describe("select_modal_controller", () => {
  let application

  beforeEach(() => {
    application = startStimulus({ "select-modal": SelectModalController })
    document.body.innerHTML = `
      <div data-controller="select-modal">
        <button type="button" data-action="click->select-modal#open">Open</button>
        <div class="hidden" data-select-modal-target="background" data-action="click->select-modal#close">
          <div data-select-modal-target="content">
            <input type="hidden" data-select-modal-target="selectedValue" name="user[role]" value="user" />
            <div
              data-select-modal-target="option"
              data-action="click->select-modal#selectOption"
              data-option-value="admin"
            >
              Admin
            </div>
          </div>
        </div>
        <span data-select-modal-target="selectedLabel">User</span>
      </div>
    `
  })

  afterEach(() => {
    application.stop()
    document.body.innerHTML = ""
  })

  it("open removes hidden from background", () => {
    const root = document.querySelector("[data-controller='select-modal']")
    const background = document.querySelector("[data-select-modal-target='background']")
    const controller = getController(application, root, "select-modal")

    expect(background.classList.contains("hidden")).toBe(true)

    controller.open({ stopPropagation: () => {} })

    expect(background.classList.contains("hidden")).toBe(false)
  })

  it("selectOption updates hidden field and label, hides modal, and dispatches selected", () => {
    const root = document.querySelector("[data-controller='select-modal']")
    const background = document.querySelector("[data-select-modal-target='background']")
    const hidden = document.querySelector("[data-select-modal-target='selectedValue']")
    const label = document.querySelector("[data-select-modal-target='selectedLabel']")
    const optionRow = document.querySelector("[data-option-value='admin']")
    const controller = getController(application, root, "select-modal")

    controller.open({ stopPropagation: () => {} })
    expect(background.classList.contains("hidden")).toBe(false)

    const dispatchSpy = vi.spyOn(controller, "dispatch")
    const changeSpy = vi.spyOn(root, "dispatchEvent")

    controller.selectOption({
      stopPropagation: () => {},
      currentTarget: optionRow
    })

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
