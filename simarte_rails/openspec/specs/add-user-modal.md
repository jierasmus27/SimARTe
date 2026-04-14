# Add User modal

**Spec id:** `add-user-modal`  
**Last updated:** 2026-04-12

## Purpose

Admins create users from **User management** via a **modal** opened by the **Add User** trigger. Creation uses **`POST /admin/users`** with Turbo Stream responses: append a row on success; replace the modal on success (reset, closed) or failure (show errors).

## Decisions (locked)

| Topic | Decision |
|--------|----------|
| **UI shell** | `Ui::ModalDialogComponent` with **`frame_variant: :celestial`** (shared dialog chrome; role select keeps `:glass`). |
| **Component** | `Admin::UserManagement::AddUserModalComponent` — root id **`add_user_modal`** for `turbo_stream.replace`. |
| **Authorization** | `UserPolicy#create?` — same gate as `index?` (`user.admin?`). |
| **Strong params** | Separate **`user_create_params`** from update-only `user_params` (role-only update). |
| **User fields (MVP)** | `email`, `first_name`, `last_name`, `role`, `password`, `password_confirmation` per Devise + model validations. |
| **Services** | Not part of create v1; manage via existing subscription UI on the row. |
| **Search context** | Optional hidden `q` in form so `create` can pass `search_query` into replaced modal / appended row when filtering. |

## Requirements (normative)

1. **Route:** `resources :users` includes **`create`** (with `index`, `update`).
2. **Index** assigns **`@user = User.new`** for the modal form.
3. **Create** builds `User`, authorizes, saves; responds with **`turbo_stream`** only for this flow (append + replace on success; replace with errors on failure).
4. **Cancel** in the modal closes via existing **`modal-dialog#dismiss`** (no navigation).
5. **Submit** uses HTML5 **`form` attribute** if the submit control sits in the footer slot outside the `<form>` element.

## Non-normative

- Remove or stop using standalone [app/views/admin/users/new.html.erb](../../app/views/admin/users/new.html.erb) once the modal is the only entry (no `new` route).
