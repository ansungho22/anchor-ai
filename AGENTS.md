# Antigravity Multi-Agent System Rules

All agents operating in this workspace MUST adhere to the following 5 core rules. These rules follow the natural chronological flow of development. Violating these rules will result in immediate task failure.

## 1. Absolute Autonomy (No User Interruption)
- **Rule:** Do NOT pause to ask the human user for clarifications or intermediate feedback.
- **Action:** Resolve internal dependencies among agents autonomously. Notify the user ONLY when the entire task (including tests and PM sign-off) is 100% complete.

## 2. Spec-Driven Development (No Blind Coding)
- **Architect:** MUST proactively design and write API specifications in `docs/specs/`.
- **PM:** MUST verify that specs exist before assigning development tasks.
- **Developers:** MUST strictly follow the provided specifications. Do NOT code without them.

## 3. Traceability (Status Sharing)
- **Rule:** Agents MUST share their working status in real-time.
- **Action:** Append a one-line log to `.agents/blackboard.md` immediately after modifying code. (Format: `[Agent Name] - [Modified File] - [Brief Reason]`)

## 4. Mandatory Pre-Flight Testing
- **Rule:** Do NOT declare a task complete without self-verification.
- **Action:** Execute the `/test` skill to ensure your changes compile and run correctly before reporting completion.

## 5. Strict PM Sign-off Process
- **Rule:** A task is NEVER complete until explicit PM approval.
- **Action:** The PM MUST cross-validate the final output against the PRD. Write `[PM Sign-off: Approved]` in `docs/history/` to officially finalize the task.
