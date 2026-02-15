@echo off
SETLOCAL EnableDelayedExpansion

echo 🔗 Initializing Multi-Agent Environment...

:: 1. Standard Junctions (Mirror the .agents folder)
if not exist ".trae"     mklink /J ".trae" ".agents"
if not exist ".kilocode" mklink /J ".kilocode" ".agents"
if not exist ".agent"    mklink /J ".agent" ".agents"
if not exist ".claude"   mklink /J ".claude" ".agents"
if not exist ".codex"    mklink /J ".codex" ".agents"

:: 2. AWS Kiro Specific Hierarchy
if not exist ".kiro" mkdir ".kiro"
if not exist ".kiro\powers" mkdir ".kiro\powers"

:: Link Kiro Steering to Rules
if not exist ".kiro\steering" mklink /J ".kiro\steering" ".agents\rules"

:: Link Kiro Powers to Skills
if not exist ".kiro\powers\installed" mklink /J ".kiro\powers\installed" ".agents\skills"

:: 3. Instruction File Sync (Root Gateway Files)
:: These ensure the AI finds your persona and routing table immediately
if not exist "AGENTS.md"    mklink /H "AGENTS.md" "CLAUDE.md"
if not exist ".cursorrules" mklink /H ".cursorrules" "CLAUDE.md"
if not exist ".traerules"   mklink /H ".traerules" "CLAUDE.md"
if not exist ".codexrules"  mklink /H ".codexrules" "CLAUDE.md"

:: 4. Kiro "POWER.md" Compatibility Loop
:: This creates hard-link aliases so Kiro is happy without duplicating data
echo ⚡ Creating POWER.md aliases for Kiro...
FOR /R ".agents\skills" %%G IN (SKILL.md) DO (
    IF NOT EXIST "%%~dpGPOWER.md" mklink /H "%%~dpGPOWER.md" "%%G"
)

echo.
echo 🚀 SETUP COMPLETE!
echo --------------------------------------------------
echo Trae:         .trae/
echo Kilo Code:    .kilocode/
echo Antigravity:  .agent/
echo Codex:        .codex/ or .codexrules
echo Kiro:         .kiro/ (with POWER.md aliases)
echo Claude Code:  .claude/
echo --------------------------------------------------
pause