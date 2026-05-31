# test

**Purpose:** Performs automated builds and runtime checks to ensure code integrity.

**Trigger:** Must be executed by agents (like Developers or QA) to verify their code before declaring a task as complete.

**Behavior:**
- Runs compiler/syntax checks.
- Attempts to start the local development server to catch runtime panics.
- Generates a timestamped test report in `docs/reports/`.
