#!/bin/bash
current_dir=$(pwd)
dir_name=$(basename "$current_dir")

read -p "Which python version?: " version

touch .tool-versions

mise use "python@$version"

mkdir .venv

poetry init --name app --python "^$version" --dev-dependency mypy@latest --dev-dependency pyright@latest --dev-dependency pytest@latest --dev-dependency ruff@latest

pip3 install -q -U ruff mypy pyright
git init -b main
touch .env
touch .gitignore
touch README.md
echo ".env" >>.gitignore
echo "__pycache__" >>.gitignore
echo ".venv" >>.gitignore

mkdir tests
mkdir "app"
mkdir "app/lib"
touch "app/lib/__init__.py"
touch "app/__init__.py"
touch "app/main.py"
touch tests/__init__.py

echo '
def main() -> None:
    print("Hello from @Roast-Lord py-init!")


if __name__ == "__main__":
    main()' >>"app/main.py"

echo '
[tool.mypy]
disallow_untyped_calls = true
disallow_subclassing_any = true
follow_imports = "normal"
warn_return_any = true
check_untyped_defs = true
disallow_untyped_defs = true
disallow_untyped_decorators = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_unreachable = true
warn_unused_configs = true
strict_equality = true
strict_concatenate = true
strict = true' >>pyproject.toml

echo '
[tool.ruff]
src = ["app", "tests"]

[tool.ruff.lint]
select = [
    "E",
    "F",
    "B",
    "PL",
    "S",
    "ASYNC",
    "UP",
    "W",
    "ANN",
    "A",
    "FBT",
    "TCH",
    "RUF",
    "I",
    "N",
    "YTT",
    "COM",
    "EM",
    "LOG",
    "G",
    "INP",
    "FA",
    "PIE",
    "T20",
    "Q",
    "RSE",
    "RET",
    "SLF",
    "SLOT",
    "SIM",
    "PTH",
    "TRY",
    "FLY",
    "C4",
    "T10",
    "ISC",
    "ICN",
    "PYI",
    "PT",
    "TID",
    "ARG",
]
ignore = [
    "E501",
    "S101",
    "PLR0913",
    "S104",
    "PLR2004",
    "ANN101",
    "ANN102",
    "A003",
    "PLR6301",
    "FBT001",
    "FBT002",
    "TCH003",
    "TCH002",
    "TCH001",
    "A002",
    "UP037",
]
unfixable = ["B", "F401", "F841"]

[tool.ruff.isort]
required-imports = ["from __future__ import annotations"]
'>>pyproject.toml

echo '
[tool.pyright]
ignore = [
    "*.pyc",
    "**/__pycache__",
    ".git",
    ".venv",
]
strict = ["app", "tests"]
exclude = ["*.pyc", "**/__pycache__", ".git", ".venv"]
include = ["app", "tests"]
'>>pyproject.toml

poetry env use $version
poetry install
poetry lock
poetry check

echo "All done! Happy coding!"
echo "(I think...)"
