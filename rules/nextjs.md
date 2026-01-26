---
description: Technical standards for Next.js 16+, React Server Components, and App Router architecture.
globs: "**/*.tsx, **/*.ts, next.config.*"
---

# Next.js 16 Engineering Standards

<Philosophy>
We build "Server-First". Client components are the exception, not the rule.
We prefer explicit caching strategies over default magic.
We separate Data Fetching (Read) from Server Actions (Write).
</Philosophy>

## 1. Folder Organization (Suggestion)

**Recommended structure** - adapts to project needs:

```text
app/
├── (auth)/              # Route group for auth pages
├── (protected)/         # Route group for authenticated routes
│   ├── dashboard/
│   ├── settings/
│   ├── components/      # Route-specific components
│   └── lib/             # Route-specific utils/types
├── actions/             # Server Actions (global)
├── api/                 # API routes
components/              # Shared components
├── ui/                  # shadcn primitives
└── shared/              # Business components
hooks/                   # Custom React hooks
lib/                     # Shared utilities
data/                    # Database queries
ai/                      # AI logic (tools, agents, prompts)
```

**Check for:**
- AI logic outside `/ai` folder (should be in `/ai`)
- If Route-specific components in global `/components` then move to route folder's component
- Route groups "()" used appropriately for logical sections

## 2. Next.js 16 Breaking Changes & Async Patterns
Rule: `params` and `searchParams` are Promises. They MUST be awaited.

```tsx
// ❌ OLD (Next.js 15) - params synchronous
export default function Page({ params }: { params: { id: string } }) {
  return <div>{params.id}</div>
}

// ✅ NEW (Next.js 16) - params is Promise
export default async function Page({
  params
}: {
  params: Promise<{ id: string }>
}) {
  const { id } = await params
  return <div>{id}</div>
}

// ✅ Type helpers (Next.js 16)
import type { PageProps, LayoutProps } from "next"

export default async function Page(props: PageProps<"/users/[id]">) {
  const { id } = await props.params
  return <UserProfile id={id} />
}
```

## 3. Data Fetching & Caching

Trigger Skill: `/cache-components`
- Read Operations: MUST use Server Components with 'use cache'.
- rite Operations: MUST use Server Actions.
- Forbidden: DO NOT use Server Actions for fetching data.

## 4. UI & Styling Standards

Trigger Skill: `/nextjs-shadcn`
*   **Aesthetic:** Glassmorphism.
*   **Implementation:** Define a `.glass` utility in `globals.css`:
    ```css
    @layer utilities {
      .glass {
        @apply bg-background/60 backdrop-blur-lg border border-border/50 shadow-sm;
      }
      .glass-card {
        @apply bg-card/60 backdrop-blur-md border border-border/50;
      }
    }
    ```
- Variables: Use CSS variables (`bg-primary`). Never hardcode hex values.
- Composition: `page.tsx` should only compose components. Logic belongs in `components/`.

## 5. Client Component Usage

Trigger Skills: `/vercel-react-best-practices`, `/react-useeffect`
- `"use client"` goes at the leaf node possible.
- Effect Policy: invoke `/react-useeffect` before writing any `useEffect`.  
    - Forbidden: Using `useEffect` to derive state from props (do it in render).
    - Forbidden: Using `useEffect` for user events (use Event Handlers).
- Performance: Use `useTransition` for state updates that cause layout shifts.

## 6. Using Next.js Documentation (MCP)

When `next-devtools` MCP is available, use it to verify patterns against official docs:

### Available MCP Tools

- `mcp__next-devtools__nextjs_docs` - Fetch official Next.js documentation by path
- `mcp__next-devtools__nextjs_index` - Discover running Next.js dev servers
- `mcp__next-devtools__nextjs_call` - Call Next.js MCP tools (get_errors, etc.)

### When to Use MCP

1. **Verify cache patterns** - Fetch `/docs/app/getting-started/caching-and-revalidating`
2. **Check Server Component rules** - Fetch `/docs/app/getting-started/server-and-client-components`
3. **Validate layout patterns** - Fetch `/docs/app/getting-started/layouts-and-pages`
4. **Confirm Server Action usage** - Fetch `/docs/app/getting-started/updating-data`

### Example Usage

When reviewing cache patterns and unsure about current best practices:

1. Use `mcp__next-devtools__nextjs_docs` with path from `nextjs-docs://llms-index`
2. Compare project code against official patterns
3. Include doc references in report when flagging issues

### Integration with Running Dev Server

If the project has a running Next.js dev server:

1. Use `mcp__next-devtools__nextjs_index` to discover the server
2. Use `mcp__next-devtools__nextjs_call` with `get_errors` to check for runtime issues
3. Include any MCP-discovered errors in the review report

## Notes

- When unsure, classify as "Recommendation" not "Critical"
- Include file paths and line numbers when possible
- Reference the `/nextjs-shadcn` skill for pattern details
- Reference the `/cache-components` skill for caching details


