# Antigravity Skills & Hooks Directory

This document outlines the automated skills and lifecycle hooks available in this Multi-Agent System. Agents can trigger these skills to automate repetitive tasks and maintain project standards.

## 1. Available Skills

Skills are standalone scripts that agents can execute to perform complex environment operations.

### 1.1 `/init` Skill (`.agents/skills/init/run.sh`)
**Purpose:** Scans the target repository to understand the environment and stack.
**Trigger:** Executed once at the beginning of a project or when significant structural changes occur.
**Behavior:**
- Detects package managers (`package.json`, `pyproject.toml`, etc.).
- Maps out the core folder structure.
- Outputs the findings to `.agents/context.md` for all agents to read and share.

### 1.2 `/test` Skill (`.agents/skills/test/run.sh`)
**Purpose:** Performs automated builds and runtime checks to ensure code integrity.
**Trigger:** Can be called manually by the QA Engineer, Backend Dev, or Frontend Dev, and is automatically triggered by the `post-task.sh` hook.
**Behavior:**
- Runs compiler/syntax checks.
- Attempts to start the local development server to catch runtime panics.
- Generates a timestamped test report in `docs/reports/`.

---

## 2. Lifecycle Hooks

Hooks are scripts that run automatically at specific points in the agent workflow.

### 2.1 `post-task.sh` (`.agents/hooks/post-task.sh`)
**Purpose:** Enforces continuous integration and traceability after an agent finishes a work item.
**Trigger:** Automatically invoked by the orchestrator when an agent marks a task as "done".
**Behavior:**
- Triggers the `/test` skill in the background to ensure the latest changes didn't break the build.
- Leaves an automated system message in `.agents/blackboard.md` to prompt the **PMO Agent** to document the changes in `docs/history/`.

---

## How to add a new skill
1. Create a new directory under `.agents/skills/<skill_name>/`.
2. Place the executable script (e.g., `run.sh` or `run.py`) inside it.
3. Update this `SKILLS.md` file with the description and trigger conditions.
