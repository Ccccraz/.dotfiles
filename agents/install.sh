#!/usr/bin/env bash
# agents/install.sh — 清单内嵌的第三方资产安装/校验 + 共享指令分发
#
# 用法:
#   install.sh [--dry-run]           依次执行 AGENTS.md、skills 和 MCP 安装
#   install.sh --links [--dry-run]   分发 agents/AGENTS.md(reasonix、zcode 复制 / codex、opencode 链接)
#   install.sh --skills [--dry-run]  链接本地 skills 并安装第三方 skills
#   install.sh --mcp [--dry-run]     安装下方声明的第三方 MCP
#
# 设计原则:仓库只维护共享指令与本脚本,不管理工具配置文件。
set -euo pipefail

AGENTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
ACTION="all"

usage() {
    sed -n '2,8p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
    exit 0
}

while [ $# -gt 0 ]; do
    case "$1" in
        --links) ACTION="links"; shift ;;
        --skills) ACTION="skills"; shift ;;
        --mcp) ACTION="mcp"; shift ;;
        --dry-run) DRY_RUN=1; shift ;;
        -h|--help) usage ;;
        *) echo "未知参数: $1" >&2; usage ;;
    esac
done

# ==================== --links:AGENTS.md 分发 ====================

link_agents_file() {
    local target="$1"

    echo "> ln -sfn $AGENTS_DIR/AGENTS.md $target"
    if [ "$DRY_RUN" -eq 0 ]; then
        mkdir -p "$(dirname "$target")"
        ln -sfn "$AGENTS_DIR/AGENTS.md" "$target"
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
    echo "完成。"
}

# ==================== --skills ====================

link_local_skill() {
    local skill_name="$1"
    local source="$AGENTS_DIR/skills/$skill_name"
    local target="$HOME/.agents/skills/$skill_name"

    echo "> ln -sfn $source $target"
    if [ "$DRY_RUN" -eq 0 ]; then
        mkdir -p "$HOME/.agents/skills"
        ln -sfn "$source" "$target"
    fi
}

install_skill() {
    local repository="$1"
    local skill_name="$2"

    echo "> npx skills add $repository --skill $skill_name --global --agent universal --yes"
    if [ "$DRY_RUN" -eq 0 ]; then
        npx skills add "$repository" \
            --skill "$skill_name" \
            --global \
            --agent universal \
            --yes
    fi
}

cmd_skills() {
    echo "== skills 安装 =="
    link_local_skill "ccccr-commit-message"
    link_local_skill "ccccr-commit-pr"
    link_local_skill "ccccr-commit-main"
    link_local_skill "ccccr-worktree"
    link_local_skill "ccccr-worktree-commit-pr"
    link_local_skill "ccccr-worktree-commit-main"
    install_skill "OthmanAdi/planning-with-files" "planning-with-files-zh"
    install_skill "antfu/skills" "vite"
    install_skill "anthropics/skills" "pdf"
    install_skill "anthropics/skills" "pptx"
    install_skill "apollographql/skills" "graphql-schema"
    install_skill "apollographql/skills" "rust-best-practices"
    install_skill "bahayonghang/drawio-skills" "drawio"
    install_skill "better-auth/skills" "better-auth-best-practices"
    install_skill "claude-office-skills/skills" "excel-automation"
    install_skill "elysiajs/skills" "elysiajs"
    install_skill "trailofbits/skills" "gh-cli"
    install_skill "github/awesome-copilot" "git-flow-branch-creator"
    install_skill "nextlevelbuilder/ui-ux-pro-max-skill" "ui-ux-pro-max"
    install_skill "openai/openai-agents-python" "docs-sync"
    install_skill "pproenca/dot-skills" "zod"
    install_skill "upstash/context7" "context7-cli"
    install_skill "vercel-labs/agent-skills" "vercel-composition-patterns"
    install_skill "vercel-labs/agent-skills" "vercel-react-best-practices"
    install_skill "vercel-labs/agent-skills" "web-design-guidelines"
    install_skill "vercel-labs/skills" "find-skills"
    install_skill "wshobson/agents" "api-design-principles"
    install_skill "wshobson/agents" "postgresql-table-design"
    install_skill "wshobson/agents" "python-anti-patterns"
    install_skill "xixu-me/skills" "github-actions-docs"
    install_skill "marimo-team/skills" "*"
    echo "完成。"
}

# ==================== --mcp ====================

cmd_mcp() {
    echo "== MCP 安装 =="
    echo "> curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | bash"
    if [ "$DRY_RUN" -eq 0 ]; then
        curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | bash
    fi
    echo "完成。"
}

case "$ACTION" in
    all) cmd_links; cmd_skills; cmd_mcp ;;
    links) cmd_links ;;
    skills) cmd_skills ;;
    mcp) cmd_mcp ;;
esac
