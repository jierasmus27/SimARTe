import { describe, it, expect, beforeEach, afterEach } from "vitest"
import DropdownController from "../../../app/javascript/controllers/dropdown_controller.js"
import { getController, startStimulus } from "../helpers/stimulus_test_helpers.js"

describe("dropdown_controller", () => {
  let application

  beforeEach(() => {
    application = startStimulus({ dropdown: DropdownController })
    document.body.innerHTML = `
      <div data-controller="dropdown">
        <button type="button" aria-expanded="false" data-action="click->dropdown#toggle">Menu</button>
        <div data-dropdown-target="menu" class="hidden">Items</div>
      </div>
    `
  })

  afterEach(() => {
    application.stop()
    document.body.innerHTML = ""
  })

  it("toggle shows menu and sets aria-expanded", () => {
    const root = document.querySelector("[data-controller='dropdown']")
    const menu = document.querySelector("[data-dropdown-target='menu']")
    const button = document.querySelector("button")
    const controller = getController(application, root, "dropdown")

    controller.toggle({ stopPropagation: () => {} })

    expect(menu.classList.contains("hidden")).toBe(false)
    expect(button.getAttribute("aria-expanded")).toBe("true")
  })
})
