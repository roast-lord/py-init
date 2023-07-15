#!/bin/bash
current_dir=$(pwd)
dir_name=$(basename "$current_dir")

read -p "Which python version?: " version

asdf plugin update python

asdf install python $version

asdf local python $version

echo "Python $version has been installed successfully."

poetry init --name $dir_name --python "^$version" --dev-dependency pylint@latest --dev-dependency mypy@latest --dev-dependency black@latest --dev-dependency isort@latest --dev-dependency flake8@latest --dev-dependency pytest@latest

pip install -U pylint mypy flake8 black isort
git init -b main
touch .env
touch .gitignore
touch .tool-versions
touch README.md
echo ".env" >>.gitignore
echo "__pycache__" >>.gitignore
echo ".vscode" >>.gitignore
mkdir src
mkdir tests
mkdir src/$dir_name
mkdir src/$dir_name/lib
touch src/$dir_name/lib/__init__.py
touch src/$dir_name/__init__.py
touch src/$dir_name/main.py
touch tests/__init__.py
echo "[flake8]
ignore = E226,E302,E41,E501,E722,C901,W503,C0302" >>.flake8
echo "# Global options:

[mypy]
warn_return_any = True
check_untyped_defs = True
disallow_untyped_defs = False
disallow_subclassing_any = True" >>mypy.ini
pylint --jobs=0 --attr-naming-style=snake_case --class-naming-style=PascalCase --const-naming-style=UPPER_CASE --function-naming-style=snake_case --method-naming-style=snake_case --module-naming-style=snake_case --variable-naming-style=snake_case --disable=raw-checker-failed,bad-inline-option,locally-disabled,file-ignored,suppressed-message,useless-suppression,deprecated-pragma,use-symbolic-message-instead,logging-fstring-interpolation,missing-function-docstring,missing-module-docstring,missing-class-docstring,line-too-long,too-many-lines,unrecognized-option --generate-rcfile >>.pylintrc
