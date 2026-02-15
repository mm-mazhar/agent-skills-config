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
project-root/
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
mklink /J ".trae" ".agents"
mklink /J ".kilocode" ".agents"
mklink /J ".agent" ".agents"
mklink /J ".claude" ".agents"
```

**2. Create the Kiro Specific Structure**
AWS Kiro uses a slightly different naming convention for its rules folder. You must link your rules folder to Kiro's steering folder specifically.
```cmd
Create the directory hierarchy
    
    - mkdir ".kiro\powers"

Link your rules to Kiro's steering folder (Keep this as it was working)
    
    - mklink /J ".kiro\steering" ".agents\rules"

Link your skills folder to Kiro's "installed" powers folder
This makes .agents\skills\ai-app\SKILL.md appear as .kiro\powers\installed\ai-app\SKILL.md

    - mklink /J ".kiro\powers\installed" ".agents\skills"
```

**3. Kiro "Power" Compatibility (Renaming)**
Kiro requires `POWER.md` instead of `SKILL.md`. Run this in PowerShell to create aliases without duplicating data:

```Powershell
Get-ChildItem -Path ".agents\skills" -Filter "SKILL.md" -Recurse | ForEach-Object {
    cmd /c mklink /H "$($_.DirectoryName)\POWER.md" "$($_.FullName)"
}
```

or in `cmd`

```cmd
FOR /R ".agents\skills" %G IN (SKILL.md) DO IF NOT EXIST "%~dpGPOWER.md" mklink /H "%~dpGPOWER.md" "%G"
```

---

**4. Setup Codex**

```
project-root/
    └── .codex/
        ├── instructions.md  <-- Link your CLAUDE.md here
        └── rules/           <-- Junction to your global rules folder
```
CMD Command to link the folder version:

```cmd
mklink /J ".codex" ".agents"

mklink /H ".codexrules" "CLAUDE.md"
```
---


**5. Sync the Main Instruction Files**
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

---

### **Alternatively Run ai-setup.bat**

### How to use this for every new project:
1. Drop your .agents folder and your CLAUDE.md into the new project.
2. Run ai-setup.bat as Administrator.
3. That's it.

**Why this configuration is superior for 2026 tools:**

* **Codex Integration**: It adds the `.codex/` junction and the `.codexrules` root link. Many VS Code Codex extensions look for the folder first, then fallback to the root file. This setup covers both.

* **Antigravity (Google)**: It uses the `.agent` junction (singular). Antigravity specifically searches for this hidden folder to find tool definitions and custom behavior.

* **Kiro "Power" Aliasing**: The loop inside the script automatically manages the `SKILL.md` vs `POWER.md`requirement. Because it uses Hard Links (`/H`), your IDEs will never get "confused"—they both point to the exact same physical data.

* **Instruction Parity**: By linking `.cursorrules`, `.traerules`, and `AGENTS.md` to your `CLAUDE.md`, you ensure that no matter which "Chat" or "Builder" mode you open, the AI starts with your Senior Staff Engineer rules and your Glassmorphism design standards.



