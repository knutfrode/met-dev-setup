#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
export MAMBA_ROOT_PREFIX=$HOME/.mconda3

sudo apt-get update
sudo apt-get install -y git build-essential curl wget

# mamba / python
echo "python."
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3.sh -b -p "${HOME}/.mconda3"
source "${HOME}/.mconda3/etc/profile.d/mamba.sh"
# mamba shell init

mamba install pip
conda config --set always_yes true

# nvm
echo "install nvm, node"GENT.md
echo "--- nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# sourcing is the usual way to do it, but does not work within the script (probably because of bashrc interactive session check)
source ~/.bashrc
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

# current repos
cd ~
mkdir dev
cd dev

git config --global receive.denyCurrentBranch warn

# Install OpenDrift and dependencies
git clone https://github.com/OpenDrift/opendrift.git
cd opendrift
mamba env create -f environment.yml
mamba run -n opendrift pip install --no-deps -e .
cd ..

# Install TrajAn
git clone https://github.com/OpenDrift/trajan.git
cd trajan
mamba run -n opendrift pip install --no-deps -e .
cd ..

# git clone https://github.com/jerabaul29/2024_drift_in_the_ocean_with_ml_blue_follow_up_darpa.git
