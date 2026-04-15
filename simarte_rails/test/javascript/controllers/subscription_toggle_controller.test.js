import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";
import SubscriptionToggleController from "../../../app/javascript/controllers/subscription_toggle_controller.js";
import { getController, startStimulus } from "../helpers/stimulus_test_helpers.js";

describe("subscription_toggle_controller", () => {
  let application;

  beforeEach(() => {
    application = startStimulus({ "subscription-toggle": SubscriptionToggleController });
    document.body.innerHTML = `
      <form data-controller="subscription-toggle">
        <input type="checkbox" data-action="change->subscription-toggle#submitIfChecked" />
      </form>
    `;
  });

  afterEach(() => {
    application.stop();
    document.body.innerHTML = "";
  });

  it("submitIfChecked calls requestSubmit when checkbox becomes checked", () => {
    const form = document.querySelector("form");
    const input = document.querySelector("input");
    const spy = vi.spyOn(form, "requestSubmit").mockImplementation(() => {});
    const controller = getController(application, form, "subscription-toggle");

    input.checked = false;
    controller.submitIfChecked({ currentTarget: input });

    expect(spy).not.toHaveBeenCalled();

    input.checked = true;
    controller.submitIfChecked({ currentTarget: input });

    expect(spy).toHaveBeenCalledOnce();
    spy.mockRestore();
  });

  it("submitIfUnchecked calls requestSubmit when checkbox becomes unchecked", () => {
    const form = document.querySelector("form");
    const input = document.querySelector("input");
    const spy = vi.spyOn(form, "requestSubmit").mockImplementation(() => {});
    const controller = getController(application, form, "subscription-toggle");

    input.checked = true;
    controller.submitIfUnchecked({ currentTarget: input });

    expect(spy).not.toHaveBeenCalled();

    input.checked = false;
    controller.submitIfUnchecked({ currentTarget: input });

    expect(spy).toHaveBeenCalledOnce();
    spy.mockRestore();
  });
});
