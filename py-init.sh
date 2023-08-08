#!/bin/bash
current_dir=$(pwd)
dir_name=$(basename "$current_dir")

read -p "Which python version?: " version

asdf plugin update python

asdf install python $version

asdf local python $version

echo "Python $version has been installed successfully."

mkdir .venv

poetry init --name app --python "^$version" --dev-dependency pylint@latest --dev-dependency mypy@latest --dev-dependency black@latest --dev-dependency pytest@latest --dev-dependency ruff@latest

pip3 install -q -U ruff pylint mypy black
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
disallow_untyped_calls = false
follow_imports = "normal"
warn_return_any = true
check_untyped_defs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
implicit_optional = false
warn_redundant_casts = true
warn_unused_ignores = true
disallow_any_generics = true
no_implicit_reexport = true
warn_unused_configs = true
strict = true
pretty = true' >>pyproject.toml

echo '
[tool.ruff]
src = ["app", "tests"]
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
    "ICN",
    "TCH",
    "RUF",
    "I",
    "N",
    "YTT",
    "COM",
    "C4",
    "EM",
    "G",
    "INP",
    "FA",
    "PIE",
    "T20",
    "PYI",
    "Q",
    "RSE",
    "RET",
    "SLF",
    "SLOT",
    "SIM",
    "PTH",
    "TRY",
    "FLY",
]
ignore = [
    "E501",
    "S101",
    "UP007",
    "PLR0913",
    "S104",
    "PLR2004",
    "ANN101",
    "A003",
    "FBT001",
    "FBT002",
    "RUF012",
    "UP038",
    "TCH003",
    "TCH002",
    "TCH001",
    "T201",
]
unfixable = ["B", "F401", "F841"]
exclude = [".venv"]

[tool.ruff.isort]
required-imports = ["from __future__ import annotations"]
' >>pyproject.toml

pylint --jobs=0 --attr-naming-style=snake_case --class-naming-style=PascalCase --const-naming-style=UPPER_CASE --function-naming-style=snake_case --method-naming-style=snake_case --module-naming-style=snake_case --variable-naming-style=snake_case --disable=raw-checker-failed,bad-inline-option,locally-disabled,file-ignored,suppressed-message,useless-suppression,deprecated-pragma,use-symbolic-message-instead,logging-fstring-interpolation,missing-function-docstring,missing-module-docstring,unused-argument,missing-class-docstring,line-too-long,broad-exception-caught,unspecified-encoding,global-at-module-level,global-statement,too-many-lines,unrecognized-option,too-few-public-methods,too-many-arguments,fixme,too-many-statements,too-many-function-args --extension-pkg-whitelist=pydantic --generate-toml-config --ignored-modules=alembic.context,alembic.op >>pyproject.toml

touch pyrightconfig.json

echo '
{
    "reportGeneralTypeIssues": false,
    "exclude": [
        ".venv"
    ],
    "venvPath": ".",
    "venv": ".venv"
}' >>pyrightconfig.json

poetry install
poetry lock
poetry check

echo "All done! Happy coding!"
echo "(I think...)"
