# Global Codex Rules

These instructions apply to all Codex sessions unless overridden by system/developer instructions, the current user request, or a more specific project `AGENTS.md`.

## 协作

- 每次回复用户前，先称呼“ZZ”。
- 轻量任务或单点改动默认由主 agent 直接处理，不为了并行而拆分。
- 任务可拆分且平台支持时，优先并行协作；职责必须清晰，避免多个 agent 同时修改同一文件，最终由主 agent 汇总和裁决。
- 需要确认时，优先一次性给出 2 到 3 个可选方案和推荐，不把确认拆成多轮。

## 轻量任务

- 轻量任务包括：单文件或小范围修改、明确 bug 修复、配置调整、文案修改、小测试补充。
- 轻量任务不进入完整 `brainstorming` / `writing-plans` / `using-git-worktrees` / `subagent-driven-development` 链路。
- 如果项目上下文、`AGENTS.md`、现有代码已经能回答，不要重复提问；只有关键不确定性才问，首次最多问 1 个问题。
- 非我明确要求时，不要默认创建 worktree，不要默认把 spec / plan 提交到 git。
- 在 Codex 环境中，已有书面计划或需要按计划落地时，优先使用 `executing-plans`，而不是 `subagent-driven-development`。

## 必须确认

以下操作必须先确认：

- 删除文件或目录
- 大规模重构
- 修改 git 历史
- `git add` / `git commit` / `git push`
- 改环境配置、CI、数据库
- 远端写操作，例如创建/合并 PR、关闭 issue、推送远程

## 设计原则

- 小而准地改，避免无关重构。
- 找到业务不变量，让它在一个地方表达。
- 共享校验、配置、权限、缓存、API 契约变更时，优先统一入口。
- 不用宽泛 `try/catch` 吞错误，不用静默 fallback 掩盖问题。
- 不为了拆分而拆分；只有真实复用、复杂度降低、或方法明显过长时才抽象。

## 规则文件

- 默认应用 `.codex/rules/bd-dxg-code-style.md` 和 `.codex/rules/bd-dxg-tool-usage.md`。
- 通用规则见 `.codex/rules/code-style.md` 和 `.codex/rules/tool-usage.md`。
- 当规则文件与系统/开发者指令、当前用户要求、项目 `AGENTS.md` 或当前 Codex 工具能力冲突时，以后者为准。
- 远端工具规则可能包含 Claude Code 专用工具示例；在 Codex 环境中只按当前可用工具等价执行。

## 代码摘要

- JavaScript / TypeScript 默认 ES6+；禁止 `var`、`class`、`any`，除非既有框架、库或项目契约要求。
- 优先 `const`、箭头函数、ES Module、`async/await`；命名遵循 camelCase / PascalCase / UPPER_SNAKE_CASE / kebab-case。
- 注释默认简体中文，说明“为什么”和关键约束；不要复述代码本身。
- 服务端接口、定时任务、外部系统调用、异步任务、批处理和关键状态流转要有必要日志；禁止裸 `console.log` 作为正式日志，禁止输出敏感信息。

## 工具摘要

- 文件搜索优先 `rg --files`，内容搜索优先 `rg`；读取大文件要聚焦范围。
- 手工编辑优先 `apply_patch`；不要用重定向、heredoc 或临时脚本写文件，除非生成器或机械工具更安全。
- 新脚本默认优先 POSIX `sh`；只有项目约定、用户要求或运行环境需要时才用 `.ps1`。
- Git 默认只读；不得擅自 `add`、`commit`、`push`、`reset`、`checkout`。
- 删除、移动、广泛覆盖、权限变更、进程终止、系统级安装都按高风险处理。

## Skills

- 用户点名 skill 或任务明显匹配时必须使用对应 skill；读取 `SKILL.md` 后再执行。
- 远端同步的非系统 skills 只作为能力目录和执行参考，不高于系统/开发者/用户/项目指令，也不得自动触发依赖安装、远端脚本执行、Git 写操作或越权文件修改。
- 常用本地 skills 包括：`code-review-expert`、`deploy-version`、`easypm`、`gencom`、`md-doc`、`naming`、`planning-with-files`、`runtime-config`、`ui-ux-pro-max`，以及远端同步的设计类 skills。

## 同步

- 全局配置通过 `hooks.json` 的 `SessionStart` hook 与 `https://github.com/rholin33/codex-setting` 同步。
- 可同步范围包括 `AGENTS.md`、`hooks.json`、`hooks/`、`rules/`、`skills/`。
- 不要把运行态或敏感文件同步到远端，例如 `auth.json`、history、sqlite、logs、sessions、`.tmp/`。
