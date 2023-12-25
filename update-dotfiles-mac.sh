set -euo pipefail

cp .vimrc ~
cp .ideavimrc ~
cp .zshrc ~
mkdir -p ~/.config/nvim
cp nvim/init.lua ~/.config/nvim/init.lua