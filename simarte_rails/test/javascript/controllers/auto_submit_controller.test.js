import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";
import AutoSubmitController from "../../../app/javascript/controllers/auto_submit_controller.js";
import { getController, startStimulus } from "../helpers/stimulus_test_helpers.js";

describe("auto_submit_controller", () => {
  let application;

  beforeEach(() => {
    application = startStimulus({ "auto-submit": AutoSubmitController });
    document.body.innerHTML = `
      <form data-controller="auto-submit">
        <input type="hidden" name="user[role]" value="user" />
      </form>
    `;
  });

  afterEach(() => {
    application.stop();
    document.body.innerHTML = "";
  });

  it("calls requestSubmit on the form element", () => {
    const form = document.querySelector("form");
    const spy = vi.spyOn(form, "requestSubmit").mockImplementation(() => {});
    const controller = getController(application, form, "auto-submit");

    controller.submit();

    expect(spy).toHaveBeenCalledOnce();
    spy.mockRestore();
  });
});
