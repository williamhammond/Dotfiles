set -euo pipefail

cp .vimrc ~
cp .ideavimrc ~
cp .zshrc ~
copy .inputrc ~
mkdir -p ~/.config/nvim
cp nvim/init.lua ~/.config/nvim/init.lua