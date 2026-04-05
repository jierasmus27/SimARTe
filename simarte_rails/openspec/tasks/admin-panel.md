# Admin panel — tasks

**Related spec:** `openspec/specs/admin-panel.md`  
Decisions are locked in **Decisions (locked)** in that spec.

## Checklist

- [ ] **Route alias:** Add `as: :admin_root` (or equivalent) so `after_sign_in_path_for` / `admin_root_path` does not break (see `ApplicationController`).
- [ ] **Auth shell:** A signed-in user sees the admin panel after login (redirect to admin root).
- [ ] **Access:** Any signed-in user (per spec), unless you add admin-only rules later.
- [ ] **Layout:** One admin shell: sidebar + top bar + `turbo_frame` for main content (User management static **or** blank placeholder per nav item).
- [ ] **Sidebar:** All reference items present (five nav + New Simulation + Support + Documentation); highlighting only on the five nav items when their route is active.
- [ ] **Top bar:** System name/branding; notifications bell with **Light** dropdown (e.g. empty state copy); help link (`#`); user initials trigger with dropdown containing **logout**.
- [ ] **Names + initials:** Migration adds **required** `first_name` / `last_name`; model validations; initials helper; **registration / edit account** forms collect names; **backfill** or strategy for existing user rows (see spec).
- [ ] **No** global search in top bar for v1.
- [ ] **Logout:** User returns to login experience (root/login as per existing Devise behavior).
- [ ] **Mobile:** Hamburger + off-canvas sidebar (**option A**); no bottom nav in v1.
- [ ] **ViewComponents:** Extract repeated UI (e.g. shell, sidebar nav link, top bar) per team preference; avoid duplicating large reference HTML blindly.
- [ ] **Tests:** **System** specs (Capybara) for critical paths: login → see shell; open user menu → logout → see login. Add **request** specs if useful for redirects/namespaced routes. *Avoid duplicating the same behavior in two test types without reason.*

## Notes

- Reference HTML in the spec may include search, tables, and footer — **not** all are in scope for v1; follow the normative requirements list in the spec.
