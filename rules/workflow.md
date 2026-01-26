---
description: Standard Operating Procedure for Full-Stack Next.js 16 Development Cycles.
globs: "**/*"
---

# Development Lifecycle & Skill Triggers

Follow this sequence for every feature request or project initiation.

## Phase 0: Environment & Context (CRITICAL)
**Goal:** Align with the existing environment to prevent drift.

1.  **Package Manager Detection**
    *   **Action:** Check for lockfiles (`bun.lockb`, `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`).
    *   **Rule:** **STRICTLY** use the detected package manager for all install/run commands.
        *   If `bun` → `bun add`, `bun run`
        *   If `npm` → `npm install`, `npm run`
        *   **Do not mix** (e.g., do not use `bun` if project is `npm`).

2.  **Planning Mode Check**
    *   **Condition:** Check if the IDE/Environment has native planning.
    *   **Fallback Trigger:** `/planning-with-files` (create `task_plan.md`) if native planning is absent.

## Phase 1: Planning & Architecture
**Goal:** Define *what* we are building before writing code.

3.  **Requirement Analysis & Task Tracking**
    *   **Condition:** Check if the current environment (e.g., Antigravity, Kilo Code) has a built-in planning mode.
    *   **Primary Action (Native Mode):** Use the environment's native planner to define steps/phases.
    *   **Fallback Trigger (No Native Mode):** `/planning-with-files`
        *   **Action:** Create `task_plan.md`. Break down requirements into atomic phases.
    *   **Universal Rule:** Never start coding without a defined plan.
    *   **AI Feature Check:** If building AI features, **ASK USER:** "Which LLM provider/model should I use? (e.g., Anthropic, OpenAI, OpenRouter)".

4.  **Brand & Design Specs**
    *   **Trigger:** `/brand-guidelines` (Only if matching specific Anthropic style) OR `/frontend-design`.
    *   **Constraint:** If the project uses `globals.css` with CSS variables/themes (e.g., Orange/Green/Blue), **prioritize existing CSS variables** over external brand guidelines hardcoded hex values.

## Phase 2: Design & UI Composition
**Goal:** Create the visual structure using established systems.

5.  **Component & Layout Design**
    *   **Trigger:** `/frontend-design`
    *   **Action:** Create high-fidelity visual components. Create visual components using Shadcn primitives. 
    *   **Design System:** **GLASSMORPHISM**. 
        *   Use `backdrop-blur-md` or `lg`.
        *   Use semi-transparent backgrounds (e.g., `bg-background/60` or `bg-white/10`).
        *   Use subtle white/light borders (`border-white/20`) to define edges.
    *   **Constraint:** Do not implement logic yet; focus on the visual shell.

6.  **System Implementation (Shadcn/Tailwind)**
    *   **Trigger:** `/nextjs-shadcn`
    *   **Action:** Scaffold project structure. Install Shadcn primitives. Ensure imports use `@/` alias.

## Phase 3: Core Implementation (Next.js 16 + Supabase)
**Goal:** Implement logic, data fetching, Auth and interactivity.

7.  **Component Logic & State**
    *   **Trigger:** `/react-useeffect`
    *   **When:** Writing `useEffect`, `useState`, or handling user interactions.
    *   **Check:** Can this state be derived during render? Is this Effect necessary?
    *   **Action:** Replace unnecessary Effects with event handlers or derived state.

8.  **React Performance**
    *   **Trigger:** `/vercel-react-best-practices`
    *   **When:** Finalizing client components and hooks.
    *   **Checks:** Bundle size, render cycles, `useTransition` usage.

9.  **Authentication & Security**
    *   **Trigger:** `/nextjs-supabase-auth`
    *   **Action:** Implement Auth/Middleware/RLS using Supabase SSR patterns.
    *   **Rule:** Protect Server Actions using `getUser` verification.

10.  **Data Architecture (CRITICAL)**
    *   **Trigger:** `/supabase-postgres-best-practices` AND `/cache-components`
    *   **Action:** Design DB Schema -> Generate Migrations -> Implement Data Fetching.
    *   **Rule:**
        *   **Read:** Server Components + `'use cache'` + Supabase Server Client.
        *   **Write:** Server Actions + `updateTag` + Supabase Server Client.

11.  **SEO & Metadata**
    *   **Trigger:** `/nextjs-seo`
    *   **When:** Creating new pages (`page.tsx`) or layouts.

12.  **AI Logic Implementation (If applicable)**
    *   **Trigger:** `/ai-app` (or specific AI SDK skill)
    *   **Config:** Configure selected Provider (OpenRouter/Anthropic) from Phase 1.

## Phase 4: Verification & Polish
**Goal:** Ensure quality before shipping.

13.  **Visual Audit**
    *   **Trigger:** `/web-design-guidelines`
    *   **Action:** Review UI against accessibility and UX standards.

14. **Functional Testing**
    *   **Trigger:** `/webapp-testing`
    *   **Action:** Write Playwright scripts to verify user flows.