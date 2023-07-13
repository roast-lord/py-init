#!/bin/bash
current_dir=$(pwd)
dir_name=$(basename "$current_dir")

read -p "Which python version?: " version

asdf plugin update python

asdf install python $version

asdf local python $version

echo "Python $version has been installed successfully."

poetry init --name $dir_name --python "^$version" --dev-dependency pylint@latest --dev-dependency mypy@latest --dev-dependency black@latest --dev-dependency isort@latest --dev-dependency flake8@latest

git init -b main
touch .env
touch .gitignore
touch .tool-versions
touch README.md
echo ".env" >>.gitignore
echo "__pycache__">>.gitignore
echo ".vscode">>.gitignore
mkdir src
mkdir tests
mkdir src/$dir_name
touch src/$dir_name/__init__.py
touch tests/__init__.py
