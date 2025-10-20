#!/bin/bash --login

set -euo pipefail

echo "Verifying language runtimes ..."

echo "- Python:"
python3 --version
unset PYENV_VERSION 2>/dev/null || true
pyenv versions | sed 's/^/  /'

echo "- Node.js:"
if command -v nvm >/dev/null 2>&1; then
    for version in "18" "20" "22"; do
        if nvm ls "${version}" >/dev/null 2>&1; then
            nvm use --silent "${version}"
            node --version
            npm --version
            pnpm --version
            yarn --version
            npm ls -g || true
        else
            echo "  skipping Node ${version} (not installed)"
        fi
    done
else
    echo "  skipping (nvm not installed)"
fi

echo "- Bun:"
if command -v bun >/dev/null 2>&1; then
    bun --version
else
    echo "  skipping (bun not installed)"
fi

echo "- Java / Gradle:"
if command -v java >/dev/null 2>&1; then
    java -version
    javac -version
    gradle --version | head -n 3
    mvn --version | head -n 1
else
    echo "  skipping (java toolchain not installed)"
fi

if [ "$TARGETARCH" = "amd64" ]; then \
    echo "- Swift:"
    if command -v swift >/dev/null 2>&1; then
        swift --version
    else
        echo "  skipping (swift not installed)"
    fi
fi

echo "- Ruby:"
if command -v ruby >/dev/null 2>&1; then
    ruby --version
else
    echo "  skipping (ruby not installed)"
fi

echo "- Rust:"
if command -v rustc >/dev/null 2>&1 && command -v cargo >/dev/null 2>&1; then
    rustc --version
    cargo --version
else
    echo "  skipping (rust toolchain not installed)"
fi

echo "- Go:"
if command -v go >/dev/null 2>&1; then
    go version
else
    echo "  skipping (go not installed)"
fi

echo "- PHP:"
if command -v php >/dev/null 2>&1; then
    php --version
    composer --version
else
    echo "  skipping (php not installed)"
fi

echo "- Elixir:"
if command -v elixir >/dev/null 2>&1; then
    elixir --version
    erl -version
    erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell
else
    echo "  skipping (elixir not installed)"
fi

echo "All language runtimes detected successfully."
