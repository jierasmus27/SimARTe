import { describe, it, expect, beforeEach, afterEach } from "vitest"
import ModalController from "../../../app/javascript/controllers/modal_controller.js"
import { getController, startStimulus } from "../helpers/stimulus_test_helpers.js"

describe("modal_controller", () => {
  let application

  beforeEach(() => {
    application = startStimulus({ modal: ModalController })
    document.body.innerHTML = `<div data-controller="modal"></div>`
  })

  afterEach(() => {
    application.stop()
    document.body.innerHTML = ""
  })

  it("connect adds open class", () => {
    const el = document.querySelector("[data-controller='modal']")
    expect(el.classList.contains("open")).toBe(true)
  })

  it("close removes element from DOM", () => {
    const el = document.querySelector("[data-controller='modal']")
    const controller = getController(application, el, "modal")

    controller.close()

    expect(document.body.contains(el)).toBe(false)
  })
})
