# Anchor AI Multi-Agent Harness

A highly structured, plug-and-play multi-agent development environment built for the Antigravity Orchestrator. This harness is designed to enforce enterprise-grade software development lifecycles (SDLC) entirely driven by autonomous AI agents.

## 🚀 Core Philosophy (The 5 Constitutions)
All agents in this workspace are strictly bound by the following rules (see `.agents/AGENTS.md`):
1. **Absolute Autonomy**: No user interruption. Agents resolve dependencies internally.
2. **Spec-Driven Development**: No blind coding. Architects write specs, PMs verify them, and Devs execute them.
3. **Traceability**: All actions and code modifications are logged in real-time to the Blackboard.
4. **Pre-Flight Testing**: Devs must run the `/test` skill to verify their builds before reporting completion.
5. **Strict PM Sign-off**: Nothing is complete until the Project Manager approves it against the PRD.

## 🤖 The 13-Agent Roster
The system is powered by 13 highly specialized agents, each with strictly defined boundaries and tool permissions:
- **Planning & Management**: `pm` (Project Manager), `pmo` (Project Management Office), `requirements_analyst`
- **Design & Architecture**: `architect`, `ui_ux_designer`
- **Development**: `frontend_dev`, `backend_dev`, `ai_dev`, `data_engineer`
- **Review & Operations**: `qa_engineer`, `security_expert`, `dba`, `devops_mlops`

### 🛡️ Defect Pipeline & Permission Control
- **Blocked Paths**: Agents cannot modify their own configurations or the system rules. Only the `devops_mlops` agent can modify automation scripts.
- **PM-Centric Defect Pipeline**: When QA, Security, UI/UX, or DevOps agents find logic flaws, vulnerabilities, or build errors, they **do not fix them**. Instead, they report them directly to the `pm` agent, who orchestrates the bug-fix assignments to the developers.

## 🛠️ Getting Started

1. **Clone the Repository**
   ```bash
   git clone https://github.com/ansungho22/anchor-ai.git
   cd anchor-ai
   ```

2. **Initialize the Environment**
   Trigger the `init` skill via your agent orchestrator to bootstrap the workspace:
   ```bash
   # This will generate the necessary docs/ directories, context file, and the agent blackboard.
   /init
   ```

3. **Begin Development**
   Simply provide your raw idea or feature request to the `requirements_analyst` agent, and watch the pipeline orchestrate itself!
