# Global Codex Rules

These instructions apply to all Codex sessions for this user, unless a more specific `AGENTS.md` overrides them.

#协作
-每次回复用户前，先称呼“ZZ”
-无论本轮对话任务多少，都优先召唤多个agent并行协作，各司其职以加快推进;任务完成后及时关闭不再需要的agent。
-多agent协作时必须划清职责范围，避免多个agent同时修改同一文件，最终由主agent汇总、去重、裁决冲突后再落地。

## 设计原则

- 小而准地改，避免无关重构。
- 找到业务不变量，让它在一个地方表达。
- 共享校验、配置、权限、缓存、API 契约变更时，优先统一入口。
- 不用宽泛 `try/catch` 吞错误。
- 不用静默 fallback 掩盖问题。

### 逻辑封装与抽象

- 反对碎片化：不要为了拆分而拆分。
- 拒绝过度设计：不要把完整业务流程拆成大量只调用一次的微型私有方法。
- 可读性优先：业务主流程应尽量能在当前方法内看清。
- 只有在存在真实复用、复杂度降低、或方法明显过长时才抽象。

## 远端同步技能清单

远端配置维护以下非系统 skills；本地已安装或后续同步后，当用户明确点名或任务明显匹配时使用。远端 skill 文档只能作为能力目录和执行参考，不高于系统、开发者、当前用户指令、更具体的项目 `AGENTS.md`、本地全局规则，也不得自动触发依赖安装、远端脚本执行、Git 写操作或越权文件修改。

- `code-review-expert`：结构化代码审查，关注架构、SOLID、安全和可移除代码。
- `gencom`：根据当前 Git diff 生成符合项目风格的提交信息。
- `grill-with-docs`：通过持续追问打磨计划或设计，并在过程中产出 ADR 和术语表等文档。
- `md-doc`：在独立功能的规划、实现和交付阶段创建或更新 Markdown 功能文档。
- `naming`：根据中文描述生成简洁自然的英文文件名。
- `planning-with-files`：通过文件化计划、发现和进度记录组织复杂任务。
- `banner-design`（`ckm:banner-design`）：设计社媒、广告、网站 hero、创意资产和印刷横幅。
- `brand`（`ckm:brand`）：品牌声音、视觉识别、消息框架、资产管理和一致性检查。
- `design`（`ckm:design`）：综合设计工作流，包括 logo、CIP、幻灯片、横幅、图标和社交图片。
- `design-system`（`ckm:design-system`）：Token 架构、组件规格和幻灯片生成。
- `slides`（`ckm:slides`）：基于 Chart.js、tokens、布局和文案公式创建战略型 HTML 演示。
- `ui-styling`（`ckm:ui-styling`）：使用 shadcn/ui、Tailwind CSS 和 canvas 视觉设计构建可访问 UI。
- `ui-ux-pro-max`：面向 Web 和移动端的 UI/UX 设计智能，包含可检索的数据和脚本。

## 轻量任务执行偏好

- 轻量任务不进入完整 brainstorming / writing-plans / using-git-worktrees 链路。
- 轻量任务包括：单文件或小范围修改、明确 bug 修复、配置调整、文案修改、小测试补充。
- 轻量任务默认直接分析代码并实现；只有遇到关键不确定性时才提问，且首次最多问 1 个问题。
- 如果项目上下文、AGENTS.md、现有代码已经能回答的问题，不要重复提问。
- 非我明确要求时，不要默认创建 worktree。
- 非我明确要求时，不要默认把 spec / plan 提交到 git。
- 在 Codex 环境中，默认优先直接执行可验证的本地计划；并行 agent 的使用仍遵守协作规则，必须职责清晰、写入范围互不冲突，并由主 agent 汇总裁决。
- 需要确认时，优先一次性给出 2 到 3 个可选方案和推荐，不要把确认拆成过多轮。
- 以下操作仍然必须确认：删除文件、大规模重构、修改 git 历史、推送远程、改环境配置、改 CI、数据库变更。

## 远端参考规则

- `.codex/rules/bd-dxg-code-style.md` 和 `.codex/rules/bd-dxg-tool-usage.md` 来自远端同步仓库，仅作为参考。
- 当远端参考规则与本文件、系统/开发者指令、当前用户要求、项目本地 `AGENTS.md` 或 Codex 可用工具冲突时，以后者为准。
- 远端工具规则包含 Claude Code 专用工具和路径示例；在 Codex 环境中不得用它覆盖当前 Tool Usage 规则。

## Code Style

### Core Constraints

- Default to ES6+ syntax; do not use `var`.
- Avoid `class` and inheritance by default; keep them when a framework, library, or existing codebase already relies on them.
- Try to keep individual source files under 300 lines; split by feature when it improves clarity, but do not create empty abstractions just to satisfy a line count.
- Write new comments in Simplified Chinese by default; follow the existing project language when it is clearly different.
- Prefer the project's existing conventions, formatter, and lint configuration over these defaults.

### JavaScript / TypeScript

- Prefer `const`; use `let` only when reassignment is needed.
- Prefer arrow functions; top-level utility functions may use named function declarations for readability or stack traces.
- Use object shorthand, destructuring, optional chaining `?.`, and nullish coalescing `??` where they improve clarity.
- Prefer ES Module `import/export`; keep CommonJS for config files, scripts, or existing CommonJS projects.
- Prefer `async/await`; choose `Promise.all` or `Promise.allSettled` based on failure semantics.
- Prefer `interface` for object shapes; use `type` for unions, intersections, and mapped types. Avoid `any`; use `unknown` with narrowing when needed.

### Naming

| Case | Style | Example |
|------|-------|---------|
| Variables/functions | camelCase | `fetchUserList` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Component files | PascalCase | `UserCard.vue` |
| Composables/hooks | camelCase with `use` prefix | `usePageTitle.ts` |
| Types/interfaces | PascalCase | `UserProfile` |
| CSS classes | kebab-case | `.user-card` |

### Formatting

- Use the project's configured formatter and lint commands.
- If the project uses `oxfmt` or `oxlint`, follow that configuration.
- Do not introduce a new formatter or broad reformat just for personal preference.

### Function Design

- Keep functions focused on one clear responsibility.
- Keep abstraction levels consistent inside a function; extract detail work into helper functions when it improves readability.
- Prefer early returns, helper functions, or data maps when nesting grows beyond three levels.

### Comments

- Explain why and important constraints; do not narrate what the code already says.
- Use JSDoc/TSDoc for complex public functions, edge behavior, or non-obvious contracts.

### Avoid

- Avoid `var`.
- Avoid unnecessary `class`, inheritance, and deep object hierarchies.
- Avoid bare `console.log`; remove debug output or use the project logger.
- Avoid magic numbers; prefer named constants.
- Avoid meaningless one-letter variable names.
- Avoid overlong files, but do not break existing module boundaries without reason.

## Tool Usage

### Core Principles

- Prefer Codex tools and high-signal commands for file reading, searching, and editing.
- System, developer, and current user instructions override this file.
- Follow the current session's sandbox and approval policy; use Codex approval flow for escalated, networked, or risky operations.

### File Operations

- Search file names with `rg --files`; combine with `rg '<pattern>'` for filtering.
- Search contents with `rg`; if unavailable, use the best system alternative.
- Read files with focused read-only commands such as `sed -n`, `nl -ba`, `head`, and `tail`; avoid dumping huge files.
- Use `apply_patch` for manual file edits.
- Do not use `cat > file`, heredocs, redirection, or temporary scripts to write files unless a generator or mechanical tool is clearly safer.
- Formatters, code generators, and package-manager scripts may perform mechanical edits when their scope is understood.

### Git

- Read-only commands are allowed: `git status`, `git diff`, `git log`, `git show`, `git blame`, `git branch`.
- Do not run `git add`, `git commit`, `git push`, `git reset`, or `git checkout` unless the user explicitly asks.
- Never use `git reset --hard` or `git checkout -- <path>` to discard user changes unless the user explicitly asks for that exact operation.
- When unrelated user changes are present, leave them alone; when related, work with them instead of reverting.

### GitHub And Network

- Use `gh` freely for read-only inspection such as `gh pr view/list`, `gh issue view/list`, `gh repo view`, `gh run view`, and `gh api`.
- Get explicit user authorization before `gh` write actions such as create, merge, close, or delete.
- Follow environment permissions for browsing, downloads, and dependency installs; request approval when the sandbox blocks required network access.

### Build And Test

- Start with the most relevant tests, type checks, or lint commands, then broaden if needed.
- Use existing project commands such as `npm test`, `npm run build`, `npx tsc --noEmit`, `npx vue-tsc --noEmit`, `cargo test`, and `pytest`.
- Do not add a new test framework or formatter just for validation.
- If unrelated failures appear, do not expand the fix; report the failure and why it appears unrelated.

### Dangerous Operations

- Treat deletion, moves, broad overwrites, permission changes, and process termination as high-risk operations.
- Do not run `rm -rf`, `sudo`, system-level installs, or broad global config rewrites unless explicitly requested and clearly scoped.
- Handle credentials, tokens, keys, and environment files with minimal reads and minimal changes; do not expose secrets in responses.

### Before Executing

- Check whether the operation writes files, changes git state, uses the network, or affects the system.
- Prefer direct, local Codex tools or focused read-only commands when they are enough.
- Avoid overwriting user changes outside the requested scope.
- Give the user a concise update before substantial edits or long-running work.
