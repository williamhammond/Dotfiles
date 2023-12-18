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

# Set fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 12

# enable keyboard navigation to move focus between controls (tab / shift-tab
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# default behavior when holding down a key is to bring up a menu of characters with different diacritical marks.
# Try holding down ‘e’ to see this in action. If you want to instead repeat characters when a key is held:
defaults write -g ApplePressAndHoldEnabled -bool false