#!/usr/bin/env bash
# agents/install.sh — 共享指令分发 + 本地/第三方 skills 安装
#
# 用法:
#   install.sh [--dry-run]           依次执行 AGENTS.md 和 skills 安装
#   install.sh --links [--dry-run]   分发 agents/AGENTS.md(reasonix、zcode 复制 / codex、opencode、dsh、claude 链接)
#   install.sh --skills [--dry-run]  链接本地 skills 并安装第三方 skills
#
# 设计原则:仓库只维护共享指令与本脚本,不管理工具配置文件。
set -euo pipefail

AGENTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
ACTION="all"

usage() {
    sed -n '2,7p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
    exit 0
}

while [ $# -gt 0 ]; do
    case "$1" in
        --links) ACTION="links"; shift ;;
        --skills) ACTION="skills"; shift ;;
        --dry-run) DRY_RUN=1; shift ;;
        -h|--help) usage ;;
        *) echo "未知参数: $1" >&2; usage ;;
    esac
done

# ==================== --links:AGENTS.md 分发 ====================

link_agents_file() {
    local target="$1"
    local source="$AGENTS_DIR/${2:-AGENTS.md}"

    echo "> ln -sfn $source $target"
    if [ "$DRY_RUN" -eq 0 ]; then
        mkdir -p "$(dirname "$target")"
        ln -sfn "$source" "$target"
    fi
}

copy_agents_file() {
    local target="$1"

    echo "> rm -f $target"
    echo "> cp $AGENTS_DIR/AGENTS.md $target"
    if [ "$DRY_RUN" -eq 0 ]; then
        mkdir -p "$(dirname "$target")"
        rm -f "$target"
        cp "$AGENTS_DIR/AGENTS.md" "$target"
    fi
}

cmd_links() {
    echo "== AGENTS.md 分发 =="
    copy_agents_file "$HOME/.reasonix/AGENTS.md"
    copy_agents_file "$HOME/.zcode/AGENTS.md"
    link_agents_file "$HOME/.codex/AGENTS.md"
    link_agents_file "$HOME/.config/opencode/AGENTS.md"
    # deepseek-harness 全局指令:$DSH_HOME/AGENTS.md(DSH_HOME 未设置时默认 ~/.dsh)
    link_agents_file "${DSH_HOME:-$HOME/.dsh}/AGENTS.md"
    # Claude Code:CLAUDE.md 的 @AGENTS.md 按软链真实路径导入本目录的 AGENTS.md;
    # 不要再链接 ~/.claude/AGENTS.md,否则会被重复加载
    link_agents_file "$HOME/.claude/CLAUDE.md" "CLAUDE.md"
    echo "完成。"
}

# ==================== --skills ====================

link_local_skill() {
    local skill_name="$1"
    local source="$AGENTS_DIR/skills/$skill_name"
    local target="$HOME/.agents/skills/$skill_name"
    local claude_target="$HOME/.claude/skills/$skill_name"

    echo "> ln -sfn $source $target"
    echo "> ln -sfn $target $claude_target"
    if [ "$DRY_RUN" -eq 0 ]; then
        mkdir -p "$HOME/.agents/skills" "$HOME/.claude/skills"
        ln -sfn "$source" "$target"
        ln -sfn "$target" "$claude_target"
    fi
}

install_skill() {
    local repository="$1"
    local skill_name="$2"

    echo "> npx skills add $repository --skill $skill_name --global --agent universal claude-code --yes"
    if [ "$DRY_RUN" -eq 0 ]; then
        npx skills add "$repository" \
            --skill "$skill_name" \
            --global \
            --agent universal claude-code \
            --yes
    fi
}

cmd_skills() {
    echo "== skills 安装 =="
    link_local_skill "ccccr-agents-md"
    install_skill "trailofbits/skills" "gh-cli"
    install_skill "upstash/context7" "context7-cli"
    install_skill "vercel-labs/skills" "find-skills"
    echo "完成。"
}

case "$ACTION" in
    all) cmd_links; cmd_skills ;;
    links) cmd_links ;;
    skills) cmd_skills ;;
esac
