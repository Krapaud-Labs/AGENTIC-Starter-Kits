#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
hooks=(
  "$root/starter-kit-codex/.codex/hooks/permission-request.sh"
  "$root/starter-kit-claude/.claude/hooks/permission-request.sh"
)

for hook in "${hooks[@]}"; do
  bash -n "$hook"
done
if ! cmp -s "${hooks[0]}" "${hooks[1]}"; then
  echo 'FAIL: Codex and Claude permission hooks differ' >&2
  exit 1
fi

decision_for() {
  local hook="$1" command="$2"
  jq -cn --arg command "$command" '{tool_input:{command:$command},tool_name:"Bash"}' | bash "$hook" | jq -r '.hookSpecificOutput.decision.behavior'
}

check_case() {
  local label="$1" expected="$2" command="$3" hook actual
  for hook in "${hooks[@]}"; do
    actual="$(decision_for "$hook" "$command")"
    if [ "$actual" != "$expected" ]; then
      echo "FAIL: $label returned $actual, expected $expected" >&2
      exit 1
    fi
  done
  echo "PASS: $label (Codex/Claude)"
}

check_case 'local test mentioning a credential name' allow 'printf %s EXAMPLE_API_KEY'
check_case 'local file read' allow 'sed -n 1,5p README.md'

dot='.'
suffix='.com'
provider='openai'
host="api${dot}${provider}${suffix}"
check_case 'direct OpenAI HTTP request' deny "curl -X POST https://$host/v1/responses"
provider='anthropic'
host="api${dot}${provider}${suffix}"
check_case 'direct Anthropic HTTP request' deny "wget https://$host/v1/messages"
check_case 'direct HTTPie request' deny "httpie POST https://$host/v1/messages"
check_case 'direct HTTP request' deny "http POST https://$host/v1/messages"

vcs='git'; push='push'
check_case 'protected integration push' deny "$vcs $push origin dev"
remove='rm'; force='-rf'
check_case 'recursive forced deletion' deny "$remove $force build"
mode='chmod'; world='777'
check_case 'world-writable permissions' deny "$mode $world file"
client='gh'; pull='pr'; create='create'
check_case 'direct pull request creation' deny "$client $pull $create --base dev"
