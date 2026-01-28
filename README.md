# How to install

- go to `https://skills.sh/` or `https://github.com/numman-ali/openskills`
- find the skill you want to install
- copy the skill name
- run `npx skills add <skill-name>`
- e.g.
    - `npx skills add vercel-labs/agent-skills`
    - `npx skills add https://github.com/vercel/next.js --skill cache-components`
    - `npx openskills install anthropics/skills`
    - `npx skills add https://github.com/sickn33/antigravity-awesome-skills --skill security-review`

KIRO (Project Level)
--------------------
```
project-root/
    ├── .kiro/
    │   ├── steering/      <-- Put your Rules (.md files) here
    │   │   ├── rules.md
    │   │   └── comments.md
    │   └── skills/        <-- Put your Skills here
    │       ├── my-skill/
    │       │   └── SKILL.md
    └── AGENTS.md          <-- Main instruction file (Optional but supported)
```

KILO CODE, TRAE, ANTIGRAVITY (Project Level)
--------------------------------------------
```
proproject-root/
    ├── .kilocode/ (FOR TRAE -> .trae/, FOR ANITGRAVITY -> .agent/)
    │   ├── rules/
    │   │   ├── comments.md
    |	├── skills/               
    |   │   └── <skill name>/SKILL.md
    └── AGENTS.md
```

Create SYMLNK
-------------

- keep the real files in the following order
```
    ├── .agents/
    │   ├── rules/
    │   │   └── workflow.md
    │   └── skills/
    │       ├── ai-app/
    │       │   └── SKILL.md
    │       ├── ai-elements/
    │       │   └── SKILL.md
    │       ├── ai-sdk-6/
    ├── AGENTS.md
    └── CLAUDE.md
```

**Run the following commands in Command Prompt as an Administrator. Ensure you are in your project's root directory.**

**1. Create Directory Junctions**
These commands make the IDE-specific folders (like .trae) "mirror" your master .agents folder.
    ```cmd
    cmd
    mklink /J ".trae" ".agents"
    mklink /J ".kilocode" ".agents"
    mklink /J ".agent" ".agents"
    mklink /J ".claude" ".agents"
    ```

**2. Create the Kiro Specific Structure**
AWS Kiro uses a slightly different naming convention for its rules folder. You must link your rules folder to Kiro's steering folder specifically.
    ```cmd
    :: Create the base .kiro directory
    mkdir ".kiro"

    :: Link the steering folder specifically
    mklink /J ".kiro\steering" ".agents\rules"

    :: Link the skills folder
    mklink /J ".kiro\skills" ".agents\skills"
    ```

**3. Sync the Main Instruction Files**
Since some IDEs prefer `AGENTS.md` and others (like Claude) require `CLAUDE.md`, you should link them so changes in one reflect in the other:
    ```cmd
    mklink "CLAUDE.md" "AGENTS.md"
    ```

## Important Verification for 2026 IDEs:
- `Trae`: Ensure the folder is named `.trae` (spelled T-R-A-E).
- `Kilo Code`: It will automatically pick up any `.md` file in `.kilocode/rules/` as context.
- `Antigravity`: It specifically looks for the `.agent` folder (singular) for project-level `skills` and `rules`.
- `Kiro`: It requires rules to be in the `steering/` sub-directory to activate them as "Steering Documents". 

**Note on Deletion: If you ever need to remove these links, use the command `rmdir .trae` or `rmdir .agent`. Do not use `del`, as that may attempt to delete the files inside your master `.agents` folder.**


