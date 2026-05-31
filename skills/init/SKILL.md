# init

**Purpose:** Scans the target repository to understand the environment and stack.

**Trigger:** Executed once at the beginning of a project or when significant structural changes occur.

**Behavior:**
- Detects package managers (`package.json`, `pyproject.toml`, etc.).
- Maps out the core folder structure.
- Initializes the `docs/` directories and `blackboard.md`.
- Outputs the findings to `context.md` for all agents to read and share.
