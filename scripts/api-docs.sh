#!/bin/bash
set -e

BASE_URL="https://rapid-killer-9.github.io/mcp-toolbox-sdk-python/"
DOCS_DIR="docs"
CONTENT_DIR="$DOCS_DIR/content/en"

# Check if pydoc-markdown is available
if ! command -v pydoc-markdown &> /dev/null; then
    echo "Error: pydoc-markdown is not installed or not in PATH."
    echo "Please install it using: pip install pydoc-markdown"
    exit 1
fi

# Create directories if they don't exist
mkdir -p "$CONTENT_DIR/docs"

# Generate Home Page
cat <<'EOT' > "$CONTENT_DIR/_index.md"
---
title: "MCP Toolbox Python SDK"
layout: home
blocks:
- template: hero
  title: MCP Toolbox Python SDK
  content: |
    Welcome to the official Python SDK for the MCP Toolbox.
    This site provides the technical API reference for `toolbox-core`, `toolbox-adk`, and integration packages.

    [Get Started with the Python SDK](https://github.com/googleapis/mcp-toolbox-sdk-python)
  cta:
    text: Browse API Reference
    url: /docs/
- template: section
  content: |
    ## Packages
    
    *   **[Core](docs/Core)**: Authentication, transport, and base protocols.
    *   **[ADK](docs/ADK)**: Agent Development Kit tools.
    *   **[LangChain](docs/LangChain)**: LangChain integration.
    *   **[LlamaIndex](docs/LlamaIndex)**: LlamaIndex integration.
---
EOT

# Generate Packages Index
cat <<'EOT' > "$CONTENT_DIR/docs/_index.md"
---
title: "Packages"
type: docs
weight: 1
alwaysopen: true
---
# Package Overview
Select a package to view its exported classes, functions, and variables.
EOT

generate_pkg_doc() {
    NAME=$1
    PKG_PATH=$2
    MODULE=$3
    WEIGHT=$4
    
    DEST="$CONTENT_DIR/docs/$NAME.md"
    
    printf -- "---\ntitle: \"$NAME\"\ntype: docs\nweight: $WEIGHT\n---\n\n" > "$DEST"
    
    FULL_PYTHONPATH="packages/toolbox-core/src:packages/toolbox-adk/src:packages/toolbox-langchain/src:packages/toolbox-llamaindex/src"
    
    PYTHONPATH="$PKG_PATH/src:$FULL_PYTHONPATH" pydoc-markdown -I "$PKG_PATH/src" -m "$MODULE" --render-toc >> "$DEST"
}

# Generate documentation for each packages
generate_pkg_doc "Core" "packages/toolbox-core" "toolbox_core" 10
generate_pkg_doc "ADK" "packages/toolbox-adk" "toolbox_adk" 20
generate_pkg_doc "LangChain" "packages/toolbox-langchain" "toolbox_langchain" 30
generate_pkg_doc "LlamaIndex" "packages/toolbox-llamaindex" "toolbox_llamaindex" 40

cd "$DOCS_DIR"

# Ensure Hugo modules are up to date
if command -v hugo &> /dev/null; then
    echo "Resolving Hugo modules..."
    # Clean and sync Go modules
    if command -v go &> /dev/null; then
        go mod tidy
    fi
    # Fetch Hugo modules
    hugo mod get
    
    echo "Building Hugo site..."
    hugo --minify --baseURL "${BASE_URL}" --destination "public"
else
    echo "Hugo not found. Skipping site build."
fi
