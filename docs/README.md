# Docs Development

This documentation site is built using [Hugo](https://gohugo.io/) and [pydoc-markdown](https://pypi.org/project/pydoc-markdown/).

## Prerequisites

1.  **Hugo**: Install Hugo (Extended version recommended).
    *   MacOS: `brew install hugo`
    *   Linux: `sudo apt-get install hugo` or download from [releases](https://github.com/gohugoio/hugo/releases).
    *   Windows: `choco install hugo-extended`

2.  **Dependencies**: Install documentation tools and the SDK packages in editable mode.
    This ensures that `pydoc-markdown` can find the source code and generate API docs.
    
    ```bash
    # Install doc tools
    pip install pydoc-markdown

    # Install SDK packages in order
    pip install -e packages/toolbox-core
    pip install -e packages/toolbox-adk
    pip install -e packages/toolbox-langchain
    pip install -e packages/toolbox-llamaindex
    ```

## Building Locally

1.  **Generate API Reference**:
    Run the script to generate Markdown files from Python docstrings.
    ```bash
    ./scripts/api-docs.sh
    ```

2.  **Serve the Site**:
    Start the Hugo development server.
    ```bash
    cd docs
    hugo server -D
    ```

3.  **View in Browser**:
    Open [http://localhost:1313/mcp-toolbox-sdk-python/](http://localhost:1313/mcp-toolbox-sdk-python/)
