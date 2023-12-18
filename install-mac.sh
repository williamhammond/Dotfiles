set -euo

if ! command -v brew &> /dev/null
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle

git config --global user.email "william.t.hammond@gmail.com"
git config --global user.name "WilliamHammond"