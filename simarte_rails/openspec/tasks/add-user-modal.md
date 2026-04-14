# Add User modal — tasks

**Related spec:** [openspec/specs/add-user-modal.md](../specs/add-user-modal.md)

## Checklist

- [x] **`Ui::ModalDialogComponent`:** add `frame_variant:` (default `:glass`); pass to `Ui::ModalFrameComponent`.
- [x] **`Admin::UserManagement::AddUserModalComponent`:** trigger (Add User button), celestial dialog, header/body/footer; root id `add_user_modal`.
- [x] **`admin/users/_form`:** `form_with` → `POST admin_users_path`, fields + optional hidden `q`; submit/cancel wired (cancel → `modal-dialog#dismiss`; submit → `form="…"` if needed).
- [x] **Routes:** `only: %i[index create update]`.
- [x] **`Admin::UsersController`:** `index` sets `@user`; `create` with `user_create_params`, turbo_stream append + replace / replace on error.
- [x] **`UserPolicy#create?`:** admin-only.
- [x] **`index.html.erb`:** render Add User modal component; remove duplicate button.
- [x] **Cleanup:** removed unused `new.html.erb`.
- [x] **Tests:** integration `POST /admin/users` (success + validation failure + guest + non-admin).

## Verification

- From User management, open Add User → fill valid data → submit → new row appears, modal resets closed.
- Invalid data → errors in modal, overlay stays open (replace).
- Non-admin cannot create (403 / redirect per app).
