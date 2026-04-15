import { Application } from "@hotwired/stimulus";

/**
 * @param {Record<string, typeof import("@hotwired/stimulus").Controller>} controllers
 */
export function startStimulus(controllers) {
  const application = Application.start();
  for (const [identifier, ControllerConstructor] of Object.entries(controllers)) {
    application.register(identifier, ControllerConstructor);
  }
  return application;
}

/**
 * @param {Application} application
 * @param {Element} element
 * @param {string} identifier
 */
export function getController(application, element, identifier) {
  return application.getControllerForElementAndIdentifier(element, identifier);
}
