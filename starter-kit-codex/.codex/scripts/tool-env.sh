#!/usr/bin/env bash
set -euo pipefail
tools_home="${AGENTIC_TOOLS_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/agentic-starter-kits}"
export AGENTIC_TOOLS_HOME="$tools_home"
export AGENTIC_NPM_PREFIX="$tools_home/npm"
export AGENTIC_PYTHON_HOME="$tools_home/python"
export UV_TOOL_DIR="$AGENTIC_PYTHON_HOME/uv"
export UV_TOOL_BIN_DIR="$AGENTIC_PYTHON_HOME/bin"
export PIPX_HOME="$AGENTIC_PYTHON_HOME/pipx"
export PIPX_BIN_DIR="$AGENTIC_PYTHON_HOME/bin"
export PATH="$AGENTIC_NPM_PREFIX/bin:$AGENTIC_PYTHON_HOME/bin:$tools_home/bin:$PATH"
