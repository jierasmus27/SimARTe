# Proposal: Add User modal (ViewComponent + Turbo)

**Status:** Accepted — implemented per openspec/specs/add-user-modal.md  
**Date:** 2026-04-12

## Summary

Replace the static “Add User” control on admin User management with a **modal dialog** whose trigger opens a **celestial-styled** shell (`Ui::ModalFrameComponent` variant), containing a **real** `form_with` that **POST**s to `POST /admin/users`. Success appends a table row via Turbo Stream and resets the modal; validation errors re-render the modal with messages.

## Motivation

- Single-page admin UX: no separate `/new` round-trip for the happy path.
- Reuse shared **modal dialog** + **modal frame** components; only the frame variant differs from the role select modal (`:glass` vs `:celestial`).
- Align with Pundit (`create?`) and existing table row partial for Turbo append.

## Out of scope (v1)

- Provisioning services at create time (use existing per-row subscription toggles after the user exists).
- Non-Turbo HTML fallback beyond redirect + flash (optional follow-up).

## References

- Spec: [openspec/specs/add-user-modal.md](../specs/add-user-modal.md)
- Tasks: [openspec/tasks/add-user-modal.md](../tasks/add-user-modal.md)
