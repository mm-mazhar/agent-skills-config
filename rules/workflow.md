---
description: Standard Operating Procedure for Full-Stack Next.js 16 Development Cycles.
globs: "**/*"
---

# Development Lifecycle & Skill Triggers

Follow this sequence for every feature request or project initiation.

## Phase 1: Planning & Architecture
**Goal:** Define *what* we are building before writing code.

1.  **Requirement Analysis & Task Tracking**
    *   **Condition:** Check if the current environment (e.g., Antigravity, Kilo Code) has a built-in planning mode.
    *   **Primary Action (Native Mode):** Use the environment's native planner to define steps/phases.
    *   **Fallback Trigger (No Native Mode):** `/planning-with-files`
        *   **Action:** Create `task_plan.md`. Break down requirements into atomic phases.
    *   **Universal Rule:** Never start coding without a defined plan.

2.  **Brand & Visual Identity**
    *   **Trigger:** `/brand-guidelines`
    *   **Action:** If design specs are missing, retrieve official brand colors/typography.

## Phase 2: Design & UI Composition
**Goal:** Create the visual structure using established systems.

3.  **Component & Layout Design**
    *   **Trigger:** `/frontend-design`
    *   **Action:** Create high-fidelity visual components. 
    *   **Design System:** **GLASSMORPHISM**. 
        *   Use `backdrop-blur-md` or `lg`.
        *   Use semi-transparent backgrounds (e.g., `bg-background/60` or `bg-white/10`).
        *   Use subtle white/light borders (`border-white/20`) to define edges.
    *   **Constraint:** Do not implement logic yet; focus on the visual shell.

4.  **System Implementation (Shadcn/Tailwind)**
    *   **Trigger:** `/nextjs-shadcn`
    *   **Action:** Scaffold project structure. Install Shadcn primitives.

## Phase 3: Core Implementation (Next.js 16)
**Goal:** Implement logic, data fetching, and interactivity.

5.  **Component Logic & State**
    *   **Trigger:** `/react-useeffect`
    *   **When:** Writing `useEffect`, `useState`, or handling user interactions.
    *   **Check:** Can this state be derived during render? Is this Effect necessary?
    *   **Action:** Replace unnecessary Effects with event handlers or derived state.

6.  **React Performance**
    *   **Trigger:** `/vercel-react-best-practices`
    *   **When:** Finalizing client components and hooks.
    *   **Checks:** Bundle size, render cycles, `useTransition` usage.

7.  **Data Architecture & Caching (CRITICAL)**
    *   **Trigger:** `/cache-components`
    *   **When:** Fetching data from DB/API.
    *   **Rule:** Implement `'use cache'`, `cacheLife`, and `cacheTag`.

8.  **SEO & Metadata**
    *   **Trigger:** `/nextjs-seo`
    *   **When:** Creating new pages (`page.tsx`) or layouts.

## Phase 4: Verification & Polish
**Goal:** Ensure quality before shipping.

9.  **Visual Audit**
    *   **Trigger:** `/web-design-guidelines`
    *   **Action:** Review UI against accessibility and UX standards.

10. **Functional Testing**
    *   **Trigger:** `/webapp-testing`
    *   **Action:** Write Playwright scripts to verify user flows.