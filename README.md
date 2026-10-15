# dotfiles-claude

个人常用的 Claude Code 轻量配置与技能。

## 技能

各技能聚焦一类任务，按需使用：

- [slopscan](skills/slopscan/SKILL.md) — 审查冗余防御、无效封装和不合理的抽象，给出具体改法。
- [code-naming](skills/code-naming/SKILL.md) — 按实际使用语境改进命名，同步更新引用。
- [code-comments](skills/code-comments/SKILL.md) — 保留必要的原因、约束与接口约定，清理复述和过期内容。
- [quality-tests](skills/quality-tests/SKILL.md) — 用测试保护关键行为，避免照抄实现和无效断言。
- [no-afterimage](skills/no-afterimage/SKILL.md) — 清除废弃方案和对话过程留下的痕迹，让交付物准确表达最终需求。
- [grilling](skills/grilling/SKILL.md) — 通过逐轮提问梳理关键决策，查清事实，明确取舍。
- [readme-writer](skills/readme-writer/SKILL.md) — 根据仓库事实编写简洁、可操作的 README。

## 安装

在仓库根目录执行：

```bash
mkdir -p ~/.claude/skills
cp -r skills/* ~/.claude/skills/
```
