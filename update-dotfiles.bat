
@echo off

copy .vimrc %USERPROFILE%
copy .ideavimrc %USERPROFILE%
copy .zshrc %USERPROFILE%
copy .inputrc %USERPROFILE%
copy settings.json %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
if not exist "%localappdata%\nvim" mkdir "%localappdata%\nvim"
copy nvim\init.lua "%localappdata%\nvim\init.lua"