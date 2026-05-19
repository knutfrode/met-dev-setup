#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update

sudo apt-get install -y git build-essential curl wget tmux git

# mamba / python
echo "python."
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3.sh -b -p "${HOME}/.mconda3"
source "${HOME}/.mconda3/etc/profile.d/mamba.sh"
# mamba shell init

conda config --set always_yes true

# nvm
echo "install nvm, node"GENT.md
echo "--- nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# sourcing is the usual way to do it, but does not work within the script (probably because of bashrc interactive session check)
# source ~/.bashrc
# load nvm explicitly!
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
echo "--- node"
nvm install node
npm install -g @github/copilot
npm install -g @anthropic-ai/claude-code
npm install -g @openai/codex

# history -s "claude --dangerously-skip-permissions"
# history -s "codex --full-auto"

copilot --allow-all-tools --version

# set up dev env
# sudo chsh -s /bin/bash $USER

# cd $HOME
# mkdir dev/
# cd dev/
# git clone https://github.com/knutfrode/met-dev-setup.git

# set up gh
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

STOWT="stow -t /home/$USER"
cd ~/met-dev-setup/

$STOWT conda
$STOWT direnv
$STOWT git
$STOWT tmux
$STOWT vim
$STOWT bash

cd ~

# current repos
mkdir dev
cd dev

git config --global receive.denyCurrentBranch warn

# Install OpenDrift and dependencies
git clone https://github.com/OpenDrift/opendrift.git
cd opendrift
mamba env create -f environment.yml
conda activate opendrift
pip install --no-deps -e .

# Install TrajAn
cd ../trajan
git clone https://github.com/OpenDrift/trajan.git
pip install --no-deps -e .
cd ..

# git clone https://github.com/jerabaul29/2024_drift_in_the_ocean_with_ml_blue_follow_up_darpa.git
