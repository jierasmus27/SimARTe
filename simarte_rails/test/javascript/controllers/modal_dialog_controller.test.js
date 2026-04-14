import { describe, it, expect, beforeEach, afterEach } from "vitest"
import ModalDialogController from "../../../app/javascript/controllers/modal_dialog_controller.js"
import { getController, startStimulus } from "../helpers/stimulus_test_helpers.js"

describe("modal_dialog_controller", () => {
  let application

  beforeEach(() => {
    application = startStimulus({ "modal-dialog": ModalDialogController })
    document.body.innerHTML = `
      <div data-controller="modal-dialog">
        <button type="button" data-action="click->modal-dialog#open">Open</button>
        <div class="hidden" data-modal-dialog-target="background" data-action="click->modal-dialog#dismissBackground">
          <div data-modal-dialog-target="content">
            <p>Panel</p>
          </div>
        </div>
      </div>
    `
  })

  afterEach(() => {
    application.stop()
    document.body.innerHTML = ""
  })

  it("open removes hidden from background", () => {
    const root = document.querySelector("[data-controller='modal-dialog']")
    const background = document.querySelector("[data-modal-dialog-target='background']")
    const controller = getController(application, root, "modal-dialog")

    expect(background.classList.contains("hidden")).toBe(true)

    controller.open({ stopPropagation: () => {} })

    expect(background.classList.contains("hidden")).toBe(false)
  })

  it("dismiss adds hidden to background", () => {
    const root = document.querySelector("[data-controller='modal-dialog']")
    const background = document.querySelector("[data-modal-dialog-target='background']")
    const controller = getController(application, root, "modal-dialog")

    controller.open({ stopPropagation: () => {} })
    controller.dismiss({ stopPropagation: () => {} })

    expect(background.classList.contains("hidden")).toBe(true)
  })
})
