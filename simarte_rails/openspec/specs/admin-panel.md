# Admin panel

**Spec id:** `admin-panel`
**Last clarified:** 2026-04-05 — *decisions below are locked for v1.*

## Purpose

Authenticated users open an admin **shell** after login: **sidebar**, **top bar**, and a **main** region. For v1, **User management** is the default main content (static). **Other** primary nav items show a **blank** placeholder. Switching uses **Turbo** inside one main `turbo_frame`.

## Requirements (normative)
1. **Post-login:** After successful sign-in, the user sees the admin panel (keep `admin_root` / redirect behavior consistent — see tasks).
2. **Sidebar:** Includes the five primary items (Dashboard, Users, Services, Analytics, Settings), plus **New Simulation** (button), **Support**, and **Documentation**, matching the reference structure below.
3. **Highlighting:** Only the **five** primary nav items use a **selected** state. Support and Documentation are plain links (placeholders until real URLs exist). **New Simulation** is a button, not a selected-route item.
4. **Main content:** One `turbo_frame` (e.g. `admin_main`) contains either the static **User management** UI or a **blank** placeholder for Dashboard, Services, Analytics, Settings.
5. **Top bar:** Branding (SimARTe + tagline per mock), **notifications** (bell with **Light** dropdown — e.g. “No notifications” until a feed exists), **help** (placeholder `#` until a real URL exists), **user menu** with **logout** in a dropdown.
6. **No global search** in the top bar for v1.
7. **User control:** **Initials** from **required** `first_name` and `last_name` on `users` (migration + validations); see [Decisions (locked)](#decisions-locked).
8. **Mobile:** **Option A** — hamburger + off-canvas/drawer sidebar on small screens; **no** bottom nav bar in v1.

## Non-normative reference

The **HTML/CSS** in the [reference block](#css-layout-reference-html) below is **visual reference** only. It includes **out-of-scope** pieces for v1 (e.g. top-bar search, sample table, footer meta, bottom nav) unless you move them into normative requirements.

---

## Decisions (locked)

### Initials

- **Choice:** **B** — Add `first_name` and `last_name` to `users` via migration.
- **Validation:** Both fields are **required** (presence). Initials are derived from these names (e.g. first character of each, uppercased; define edge cases for single token if any).
- **Existing rows:** If any users exist before deploy, add a **backfill** or temporary `default: ""` + validation only after backfill — implementers must not leave production in a broken state.

### Mobile

- **Choice:** **A** — Hamburger in the top bar toggles an off-canvas/drawer sidebar on small screens; **no** bottom navigation bar in v1.

### Notifications

- **Choice:** **Light** — Bell opens a dropdown; v1 may show a single empty state such as “No notifications”.

### Help

- **Choice:** Placeholder `href="#"` until a real help URL exists.

### Access control

- **Default (unchanged):** Any **signed-in** Devise user may use the admin panel. Introduce admin-only rules later if needed.

### Routing and Turbo

- **Choice:** **Suggested default** — `admin` **namespace** with one route per primary section; **Turbo** responses update the main `turbo_frame` (e.g. `admin_main`). Named route **`admin_root`** for post-login redirect (see tasks).

### One shell vs two layouts

- **Choice:** **Confirmed** — One admin **shell** (layout wrapping sidebar + top bar). **User management** (and other sections) are **content inside the frame**, not a second full-page layout duplicating the shell.

---

## CSS layout reference (HTML)

The following is a **complete HTML document** (pretty-printed for this spec). Tailwind / fonts are assumed to be provided by your app when used for real UI.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>SimARTe admin — layout reference</title>
<style>
    .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
            body {
                background-color: #111416;
                color: #e2e6eb;
            }
            ::-webkit-scrollbar {
                width: 6px;
            }
            ::-webkit-scrollbar-track {
                background: #111416;
            }
            ::-webkit-scrollbar-thumb {
                background: #43484c;
                border-radius: 10px;
            }
  </style>
  </head>
  <body class="font-body selection:bg-primary selection:text-on-primary">
    <div class="flex min-h-screen">
      <!-- SideNavBar (Predicted Shared Component: COMPONENTS_8) -->
      <aside class="bg-[#111416] h-screen w-64 hidden md:flex flex-col border-r border-[#43484c]/15 sticky top-0">
        <div class="flex flex-col h-full py-8 space-y-2">
          <div class="px-8 mb-4">
            <h1 class="font-['Space_Grotesk'] text-xl font-black text-[#96d3bd] tracking-tighter">SimARTe</h1>
            <p class="text-[10px] text-on-surface-variant tracking-[0.2em] uppercase mt-1 font-medium">Living Observatory
            </p>
          </div>
          <nav class="flex-1 space-y-0.5 mt-8">
            <a class="flex items-center gap-3 px-8 py-3 text-[#e2e6eb]/50 hover:bg-[#282d31] hover:text-[#96d3bd] transition-all duration-300 group font-['Space_Grotesk'] font-medium"
              href="#">
              <span class="material-symbols-outlined text-xl group-hover:translate-x-1 transition-transform duration-300"
                data-icon="dashboard">dashboard</span>
              <span class="text-sm">Dashboard</span>
            </a>
            <a class="flex items-center gap-3 px-8 py-3 text-[#96d3bd] border-r-4 border-[#96d3bd] bg-gradient-to-r from-[#96d3bd]/10 to-transparent transition-all duration-300 group font-['Space_Grotesk'] font-medium"
              href="#">
              <span class="material-symbols-outlined text-xl translate-x-1" data-icon="group"
                style="font-variation-settings: 'FILL' 1;">group</span>
              <span class="text-sm">Users</span>
            </a>
            <a class="flex items-center gap-3 px-8 py-3 text-[#e2e6eb]/50 hover:bg-[#282d31] hover:text-[#96d3bd] transition-all duration-300 group font-['Space_Grotesk'] font-medium"
              href="#">
              <span class="material-symbols-outlined text-xl group-hover:translate-x-1 transition-transform duration-300"
                data-icon="layers">layers</span>
              <span class="text-sm">Services</span>
            </a>
            <a class="flex items-center gap-3 px-8 py-3 text-[#e2e6eb]/50 hover:bg-[#282d31] hover:text-[#96d3bd] transition-all duration-300 group font-['Space_Grotesk'] font-medium"
              href="#">
              <span class="material-symbols-outlined text-xl group-hover:translate-x-1 transition-transform duration-300"
                data-icon="query_stats">query_stats</span>
              <span class="text-sm">Analytics</span>
            </a>
            <a class="flex items-center gap-3 px-8 py-3 text-[#e2e6eb]/50 hover:bg-[#282d31] hover:text-[#96d3bd] transition-all duration-300 group font-['Space_Grotesk'] font-medium"
              href="#">
              <span class="material-symbols-outlined text-xl group-hover:translate-x-1 transition-transform duration-300"
                data-icon="settings">settings</span>
              <span class="text-sm">Settings</span>
            </a>
          </nav>
          <div class="mt-auto border-t border-[#43484c]/15 pt-8 px-8 space-y-1">
            <button
              class="w-full flex items-center justify-center gap-2 bg-[#96d3bd] text-[#0c0e10] py-2.5 rounded-sm font-bold text-sm mb-6 active:scale-95 transition-transform font-['Space_Grotesk']">
              <span class="material-symbols-outlined text-lg" data-icon="add">add</span>
              New Simulation
            </button>
            <a class="flex items-center gap-3 py-2 text-[#e2e6eb]/50 hover:text-[#96d3bd] transition-all font-['Space_Grotesk'] font-medium"
              href="#">
              <span class="material-symbols-outlined text-xl" data-icon="contact_support">contact_support</span>
              <span class="text-sm">Support</span>
            </a>
            <a class="flex items-center gap-3 py-2 text-[#e2e6eb]/50 hover:text-[#96d3bd] transition-all font-['Space_Grotesk'] font-medium"
              href="#">
              <span class="material-symbols-outlined text-xl" data-icon="menu_book">menu_book</span>
              <span class="text-sm">Documentation</span>
            </a>
          </div>
        </div>
      </aside>
      <!-- Main Content Area -->
      <main class="flex-1 flex flex-col min-w-0 bg-surface overflow-x-hidden">
        <!-- TopNavBar (Predicted Shared Component: COMPONENTS_8) -->
        <header class="bg-[#0c0e10]/70 backdrop-blur-3xl sticky top-0 z-50 border-b border-[#43484c]/10">
          <div class="flex justify-between items-center px-8 py-4 w-full">
            <div class="flex items-center gap-6">
              <button class="md:hidden text-[#96d3bd]">
                <span class="material-symbols-outlined" data-icon="menu">menu</span>
              </button>
              <div class="relative hidden sm:block">
                <span
                  class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant text-sm"
                  data-icon="search">search</span>
                <input
                  class="bg-[#111416] border-none text-sm py-2 pl-10 pr-4 w-72 rounded-sm focus:ring-1 focus:ring-[#96d3bd] placeholder:text-outline-variant font-['Space_Grotesk']"
                  placeholder="Global system search..." type="text" />
              </div>
            </div>
            <div class="flex items-center gap-6">
              <button class="text-[#e2e6eb]/60 hover:text-[#96d3bd] transition-colors duration-300 active:scale-95">
                <span class="material-symbols-outlined" data-icon="notifications">notifications</span>
              </button>
              <button class="text-[#e2e6eb]/60 hover:text-[#96d3bd] transition-colors duration-300 active:scale-95">
                <span class="material-symbols-outlined" data-icon="help_outline">help_outline</span>
              </button>
              <div class="h-8 w-8 rounded-sm ring-1 ring-[#43484c]/20 flex items-center justify-center overflow-hidden">
                <img alt="Administrator Profile" class="h-full w-full object-cover"
                  src="https://lh3.googleusercontent.com/aida-public/AB6AXuC6rfEVszGFRv-EPIP8hJsnF5EVD1FCAKjnmqNIhUYJvCnCeAleRYQ5la_xNDtdLWSPku8J-s93uyn2v2mjTzcwRaOQG1NCMXv-OeJ2RJ95A09BsxemBuWgXVMdTXpMODtEzy44jkjp9NTYobNjics_NsGY0z7PPTbnmenLovqhCyy4LQlUUIHrGLwcQh1fvowdqezlGpb-BuGrNo2h7HwIjmrnnqReyIVihbfpHAIK_F_rboKUXDq8Eimn0J87X_hV720kRNWETMMK" />
              </div>
            </div>
          </div>
        </header>
        <!-- Page Header -->
        <div class="px-6 sm:px-16 pt-10 pb-6">
          <div class="flex flex-col md:flex-row md:items-end justify-between gap-6">
            <div>
              <h2 class="font-headline text-4xl font-bold tracking-tight text-on-surface">User Management</h2>
              <p class="text-on-surface-variant mt-3 max-w-2xl font-body leading-relaxed">Manage system access, define
                roles, and toggle specialized AR/GIS modules for individual operators across the precision simulation
                network.</p>
            </div>
            <div class="flex gap-3">
              <button
                class="bg-surface-container border border-outline-variant/15 px-5 py-2.5 text-sm font-medium flex items-center gap-2 hover:bg-surface-container-high transition-colors font-['Space_Grotesk']">
                <span class="material-symbols-outlined text-lg" data-icon="filter_list">filter_list</span>
                Filter
              </button>
              <button
                class="bg-[#96d3bd] text-[#0c0e10] px-5 py-2.5 text-sm font-bold flex items-center gap-2 rounded-sm active:scale-95 transition-transform font-['Space_Grotesk']">
                <span class="material-symbols-outlined text-lg" data-icon="person_add">person_add</span>
                Add User
              </button>
            </div>
          </div>
        </div>
        <!-- Content Grid / Table Area -->
        <div class="px-6 sm:px-16 py-8">
          <div class="bg-surface-container border border-outline-variant/10 rounded-sm overflow-hidden shadow-none">
            <!-- Search & Tools -->
            <div
              class="p-5 bg-surface-container-low border-b border-outline-variant/5 flex flex-wrap items-center justify-between gap-4">
              <div class="relative flex-1 min-w-[320px]">
                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-primary"
                  data-icon="manage_search">manage_search</span>
                <input
                  class="w-full bg-surface-container-lowest border-none text-sm py-2.5 pl-10 pr-4 rounded-sm focus:ring-1 focus:ring-primary font-['Space_Grotesk']"
                  placeholder="Search by name, role, or active service..." type="text" />
              </div>
              <div class="flex items-center gap-4 text-xs font-label uppercase tracking-widest text-on-surface-variant">
                <span>Total Users: 254</span>
                <span class="text-primary opacity-40">•</span>
                <span>Active Sessions: 12</span>
              </div>
            </div>
            <!-- Table -->
            <div class="overflow-x-auto">
              <table class="w-full text-left border-collapse">
                <thead>
                  <tr class="bg-surface-container-low/30">
                    <th class="px-6 py-5 text-[10px] font-label uppercase tracking-[0.2em] text-on-surface-variant">User
                      Name</th>
                    <th class="px-6 py-5 text-[10px] font-label uppercase tracking-[0.2em] text-on-surface-variant">Role
                    </th>
                    <th
                      class="px-6 py-5 text-[10px] font-label uppercase tracking-[0.2em] text-on-surface-variant text-center">
                      AR</th>
                    <th
                      class="px-6 py-5 text-[10px] font-label uppercase tracking-[0.2em] text-on-surface-variant text-center">
                      3D Modeling</th>
                    <th
                      class="px-6 py-5 text-[10px] font-label uppercase tracking-[0.2em] text-on-surface-variant text-center">
                      GIS</th>
                    <th
                      class="px-6 py-5 text-[10px] font-label uppercase tracking-[0.2em] text-on-surface-variant text-right">
                      Actions</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-outline-variant/5">
                  <!-- Row 1 -->
                  <tr class="hover:bg-primary/5 transition-colors group">
                    <td class="px-6 py-5">
                      <div class="flex items-center gap-4">
                        <div
                          class="w-10 h-10 rounded-sm bg-surface-container-highest flex items-center justify-center border border-outline-variant/10">
                          <span class="material-symbols-outlined text-primary/80"
                            data-icon="account_circle">account_circle</span>
                        </div>
                        <div>
                          <div class="text-sm font-medium text-on-surface">Dr. Helena Vance</div>
                          <div class="text-xs text-on-surface-variant font-['Space_Grotesk']">h.vance@simarte.io</div>
                        </div>
                      </div>
                    </td>
                    <td class="px-6 py-5">
                      <span
                        class="inline-flex items-center px-2 py-0.5 rounded-sm text-[10px] font-bold uppercase tracking-tight bg-primary/10 text-primary border border-primary/20 font-['Space_Grotesk']">Lead
                        Scientist</span>
                    </td>
                    <td class="px-6 py-5 text-center">
                      <label class="relative inline-flex items-center cursor-pointer">
                        <input checked="" class="sr-only peer" type="checkbox" />
                        <div
                          class="w-8 h-4 bg-surface-container-lowest rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-on-surface-variant after:border-none after:rounded-full after:h-3 after:w-3 after:transition-all peer-checked:bg-primary peer-checked:after:bg-[#0c0e10]">
                        </div>
                      </label>
                    </td>
                    <td class="px-6 py-5 text-center">
                      <label class="relative inline-flex items-center cursor-pointer">
                        <input checked="" class="sr-only peer" type="checkbox" />
                        <div
                          class="w-8 h-4 bg-surface-container-lowest rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-on-surface-variant after:border-none after:rounded-full after:h-3 after:w-3 after:transition-all peer-checked:bg-primary peer-checked:after:bg-[#0c0e10]">
                        </div>
                      </label>
                    </td>
                    <td class="px-6 py-5 text-center">
                      <label class="relative inline-flex items-center cursor-pointer">
                        <input checked="" class="sr-only peer" type="checkbox" />
                        <div
                          class="w-8 h-4 bg-surface-container-lowest rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-on-surface-variant after:border-none after:rounded-full after:h-3 after:w-3 after:transition-all peer-checked:bg-primary peer-checked:after:bg-[#0c0e10]">
                        </div>
                      </label>
                    </td>
                    <td class="px-6 py-5 text-right">
                      <div class="flex justify-end gap-1">
                        <button class="p-2 text-on-surface-variant hover:text-primary transition-colors"
                          title="Reset Password">
                          <span class="material-symbols-outlined text-lg" data-icon="lock_reset">lock_reset</span>
                        </button>
                        <button class="p-2 text-on-surface-variant hover:text-primary transition-colors"
                          title="Edit Permissions">
                          <span class="material-symbols-outlined text-lg" data-icon="shield_person">shield_person</span>
                        </button>
                      </div>
                    </td>
                  </tr>
                  <!-- Row 2 -->
                  <tr class="hover:bg-primary/5 transition-colors group">
                    <td class="px-6 py-5">
                      <div class="flex items-center gap-4">
                        <div
                          class="w-10 h-10 rounded-sm bg-surface-container-highest flex items-center justify-center border border-outline-variant/10">
                          <span class="material-symbols-outlined text-secondary/80"
                            data-icon="account_circle">account_circle</span>
                        </div>
                        <div>
                          <div class="text-sm font-medium text-on-surface">Marcus Thorne</div>
                          <div class="text-xs text-on-surface-variant font-['Space_Grotesk']">m.thorne@simarte.io</div>
                        </div>
                      </div>
                    </td>
                    <td class="px-6 py-5">
                      <span
                        class="inline-flex items-center px-2 py-0.5 rounded-sm text-[10px] font-bold uppercase tracking-tight bg-secondary/10 text-secondary border border-secondary/20 font-['Space_Grotesk']">Field
                        Tech</span>
                    </td>
                    <td class="px-6 py-5 text-center">
                      <label class="relative inline-flex items-center cursor-pointer">
                        <input checked="" class="sr-only peer" type="checkbox" />
                        <div
                          class="w-8 h-4 bg-surface-container-lowest rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-on-surface-variant after:border-none after:rounded-full after:h-3 after:w-3 after:transition-all peer-checked:bg-primary peer-checked:after:bg-[#0c0e10]">
                        </div>
                      </label>
                    </td>
                    <td class="px-6 py-5 text-center">
                      <label class="relative inline-flex items-center cursor-pointer">
                        <input class="sr-only peer" type="checkbox" />
                        <div
                          class="w-8 h-4 bg-surface-container-lowest rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-on-surface-variant after:border-none after:rounded-full after:h-3 after:w-3 after:transition-all peer-checked:bg-primary peer-checked:after:bg-[#0c0e10]">
                        </div>
                      </label>
                    </td>
                    <td class="px-6 py-5 text-center">
                      <label class="relative inline-flex items-center cursor-pointer">
                        <input class="sr-only peer" type="checkbox" />
                        <div
                          class="w-8 h-4 bg-surface-container-lowest rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-on-surface-variant after:border-none after:rounded-full after:h-3 after:w-3 after:transition-all peer-checked:bg-primary peer-checked:after:bg-[#0c0e10]">
                        </div>
                      </label>
                    </td>
                    <td class="px-6 py-5 text-right">
                      <div class="flex justify-end gap-1">
                        <button class="p-2 text-on-surface-variant hover:text-primary transition-colors"
                          title="Reset Password">
                          <span class="material-symbols-outlined text-lg" data-icon="lock_reset">lock_reset</span>
                        </button>
                        <button class="p-2 text-on-surface-variant hover:text-primary transition-colors"
                          title="Edit Permissions">
                          <span class="material-symbols-outlined text-lg" data-icon="shield_person">shield_person</span>
                        </button>
                      </div>
                    </td>
                  </tr>
                  <!-- Row 3 -->
                  <tr class="hover:bg-primary/5 transition-colors group">
                    <td class="px-6 py-5">
                      <div class="flex items-center gap-4">
                        <div
                          class="w-10 h-10 rounded-sm bg-surface-container-highest flex items-center justify-center border border-outline-variant/10">
                          <span class="material-symbols-outlined text-primary/80"
                            data-icon="account_circle">account_circle</span>
                        </div>
                        <div>
                          <div class="text-sm font-medium text-on-surface">Sarah Jenkins</div>
                          <div class="text-xs text-on-surface-variant font-['Space_Grotesk']">s.jenkins@spatial.com</div>
                        </div>
                      </div>
                    </td>
                    <td class="px-6 py-5">
                      <span
                        class="inline-flex items-center px-2 py-0.5 rounded-sm text-[10px] font-bold uppercase tracking-tight bg-primary/10 text-primary border border-primary/20 font-['Space_Grotesk']">GIS
                        Analyst</span>
                    </td>
                    <td class="px-6 py-5 text-center">
                      <label class="relative inline-flex items-center cursor-pointer">
                        <input class="sr-only peer" type="checkbox" />
                        <div
                          class="w-8 h-4 bg-surface-container-lowest rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-on-surface-variant after:border-none after:rounded-full after:h-3 after:w-3 after:transition-all peer-checked:bg-primary peer-checked:after:bg-[#0c0e10]">
                        </div>
                      </label>
                    </td>
                    <td class="px-6 py-5 text-center">
                      <label class="relative inline-flex items-center cursor-pointer">
                        <input class="sr-only peer" type="checkbox" />
                        <div
                          class="w-8 h-4 bg-surface-container-lowest rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-on-surface-variant after:border-none after:rounded-full after:h-3 after:w-3 after:transition-all peer-checked:bg-primary peer-checked:after:bg-[#0c0e10]">
                        </div>
                      </label>
                    </td>
                    <td class="px-6 py-5 text-center">
                      <label class="relative inline-flex items-center cursor-pointer">
                        <input checked="" class="sr-only peer" type="checkbox" />
                        <div
                          class="w-8 h-4 bg-surface-container-lowest rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-on-surface-variant after:border-none after:rounded-full after:h-3 after:w-3 after:transition-all peer-checked:bg-primary peer-checked:after:bg-[#0c0e10]">
                        </div>
                      </label>
                    </td>
                    <td class="px-6 py-5 text-right">
                      <div class="flex justify-end gap-1">
                        <button class="p-2 text-on-surface-variant hover:text-primary transition-colors"
                          title="Reset Password">
                          <span class="material-symbols-outlined text-lg" data-icon="lock_reset">lock_reset</span>
                        </button>
                        <button class="p-2 text-on-surface-variant hover:text-primary transition-colors"
                          title="Edit Permissions">
                          <span class="material-symbols-outlined text-lg" data-icon="shield_person">shield_person</span>
                        </button>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <!-- Pagination -->
            <div class="p-5 bg-surface-container-low flex items-center justify-between border-t border-outline-variant/5">
              <div class="text-[11px] text-on-surface-variant font-medium tracking-wide font-['Space_Grotesk'] uppercase">
                Showing 1-4 of 254 entries
              </div>
              <div class="flex items-center gap-3">
                <button class="p-2 text-on-surface-variant hover:text-primary transition-colors disabled:opacity-20"
                  disabled="">
                  <span class="material-symbols-outlined text-lg" data-icon="chevron_left">chevron_left</span>
                </button>
                <div class="flex items-center gap-1.5">
                  <button
                    class="w-8 h-8 flex items-center justify-center text-xs font-bold bg-[#96d3bd] text-[#0c0e10] rounded-sm font-['Space_Grotesk']">1</button>
                  <button
                    class="w-8 h-8 flex items-center justify-center text-xs font-bold text-on-surface-variant hover:bg-surface-container transition-colors rounded-sm font-['Space_Grotesk']">2</button>
                  <button
                    class="w-8 h-8 flex items-center justify-center text-xs font-bold text-on-surface-variant hover:bg-surface-container transition-colors rounded-sm font-['Space_Grotesk']">3</button>
                  <span class="px-1 text-on-surface-variant text-xs font-['Space_Grotesk']">...</span>
                  <button
                    class="w-8 h-8 flex items-center justify-center text-xs font-bold text-on-surface-variant hover:bg-surface-container transition-colors rounded-sm font-['Space_Grotesk']">64</button>
                </div>
                <button class="p-2 text-on-surface-variant hover:text-primary transition-colors">
                  <span class="material-symbols-outlined text-lg" data-icon="chevron_right">chevron_right</span>
                </button>
              </div>
            </div>
          </div>
        </div>
        <!-- Footer Meta Info -->
        <footer
          class="mt-auto px-6 sm:px-16 py-8 border-t border-outline-variant/5 flex flex-col md:flex-row justify-between items-center gap-6">
          <div class="flex items-center gap-8">
            <div class="flex items-center gap-2">
              <span class="w-1.5 h-1.5 rounded-full bg-primary shadow-[0_0_10px_rgba(150,211,189,0.5)]"></span>
              <span class="text-[10px] font-label uppercase tracking-widest text-on-surface-variant">Core Simulation
                Engine: Online</span>
            </div>
            <div class="flex items-center gap-2">
              <span class="w-1.5 h-1.5 rounded-full bg-secondary shadow-[0_0_10px_rgba(192,201,195,0.4)]"></span>
              <span class="text-[10px] font-label uppercase tracking-widest text-on-surface-variant">Service Latency:
                14ms</span>
            </div>
          </div>
          <div class="text-[10px] font-label uppercase tracking-[0.2em] text-on-surface-variant">
            SimARTe Precision Layer v4.2.0-stabilized
          </div>
        </footer>
      </main>
    </div>
    <!-- BottomNavBar (Predicted Shared Component: COMPONENTS_8 - Mobile Only) -->
    <nav
      class="md:hidden fixed bottom-0 left-0 w-full flex justify-around items-center px-6 pb-6 pt-3 bg-[#1c2023]/80 backdrop-blur-2xl border-t border-[#43484c]/10 rounded-t-[2rem] z-50 shadow-[0_-10px_40px_rgba(150,211,189,0.06)]">
      <a class="flex flex-col items-center justify-center text-[#e2e6eb]/40 p-3 transition-transform active:scale-90"
        href="#">
        <span class="material-symbols-outlined" data-icon="home">home</span>
        <span class="font-['Space_Grotesk'] text-[10px] uppercase tracking-widest mt-1">Home</span>
      </a>
      <a class="flex flex-col items-center justify-center bg-[#96d3bd] text-[#0c0e10] rounded-full p-3 transition-transform active:scale-90"
        href="#">
        <span class="material-symbols-outlined" data-icon="person"
          style="font-variation-settings: 'FILL' 1;">person</span>
        <span class="font-['Space_Grotesk'] text-[10px] uppercase tracking-widest mt-1">Users</span>
      </a>
      <a class="flex flex-col items-center justify-center text-[#e2e6eb]/40 p-3 transition-transform active:scale-90"
        href="#">
        <span class="material-symbols-outlined" data-icon="deployed_code">deployed_code</span>
        <span class="font-['Space_Grotesk'] text-[10px] uppercase tracking-widest mt-1">Apps</span>
      </a>
      <a class="flex flex-col items-center justify-center text-[#e2e6eb]/40 p-3 transition-transform active:scale-90"
        href="#">
        <span class="material-symbols-outlined" data-icon="monitoring">monitoring</span>
        <span class="font-['Space_Grotesk'] text-[10px] uppercase tracking-widest mt-1">Data</span>
      </a>
      <a class="flex flex-col items-center justify-center text-[#e2e6eb]/40 p-3 transition-transform active:scale-90"
        href="#">
        <span class="material-symbols-outlined" data-icon="tune">tune</span>
        <span class="font-['Space_Grotesk'] text-[10px] uppercase tracking-widest mt-1">Config</span>
      </a>
    </nav>
  </body>

</html>
```

