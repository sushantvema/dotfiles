#!/bin/bash
# Setup global (user-scoped) MCP servers for Claude Code
# Run once on a new machine, or after resetting ~/.claude.json
#
# Secrets: source .secrets before running, or you'll be prompted.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Remove then add to allow re-running idempotently
add_mcp() {
  local name="$1"
  shift
  claude mcp remove --scope user "$name" 2>/dev/null || true
  claude mcp add --scope user "$@"
}

echo -e "${BLUE}=== Claude Code MCP Server Setup ===${NC}"

# --- No-secret servers ---

echo -e "${GREEN}Adding Context7...${NC}"
add_mcp Context7 -t stdio Context7 -- npx -y @upstash/context7-mcp

echo -e "${GREEN}Adding Linear...${NC}"
add_mcp linear -t stdio linear -- npx -y mcp-remote https://mcp.linear.app/sse

echo -e "${GREEN}Adding Logfire...${NC}"
add_mcp logfire -t http logfire https://logfire-us.pydantic.dev/mcp

# --- Supabase (requires token) ---

if [ -z "$HERCULES_SUPABASE_PROD_PAT" ]; then
  echo -e "${RED}HERCULES_SUPABASE_PROD_PAT not set.${NC}"
  echo -n "Enter your Supabase personal access token: "
  read -s HERCULES_SUPABASE_PROD_PAT
  echo
fi

echo -e "${GREEN}Adding Supabase...${NC}"
add_mcp supabase -t stdio supabase \
  --env SUPABASE_ACCESS_TOKEN="$HERCULES_SUPABASE_PROD_PAT" \
  -- npx -y @supabase/mcp-server-supabase@latest --read-only --project-ref=ehvopzzidrfxtvsfrfkq

echo ""
echo -e "${GREEN}Done! All MCP servers configured at user scope.${NC}"
echo -e "Verify with: ${BLUE}claude mcp list${NC}"
