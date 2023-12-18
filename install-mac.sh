set -euo

if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    brew update && brew upgrade
fi

brew bundle

git config --global user.email "william.t.hammond@gmail.com"
git config --global user.name "WilliamHammond"

if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
    ssh-keygen -t ed25519 -a 100 </dev/null
fi
