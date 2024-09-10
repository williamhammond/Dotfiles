
@echo off

copy .vimrc %USERPROFILE%
copy .ideavimrc %USERPROFILE%
copy .zshrc %USERPROFILE%
copy .inputrc %USERPROFILE%
if not exist "%localappdata%\nvim" mkdir "%localappdata%\nvim"
copy nvim\init.lua "%localappdata%\nvim\init.lua"