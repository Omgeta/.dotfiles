# Load NVM once, when an interactive Node command is first used.
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  load_nvm() {
    unfunction nvm node npm npx
    source "$NVM_DIR/nvm.sh" || return
    [[ ! -s "$NVM_DIR/bash_completion" ]] || source "$NVM_DIR/bash_completion"
  }
  nvm() { load_nvm && nvm "$@"; }
  node() { load_nvm && command node "$@"; }
  npm() { load_nvm && command npm "$@"; }
  npx() { load_nvm && command npx "$@"; }
fi

# Initialize Conda on first use, without activating base at shell startup.
export CONDA_HOME="${CONDA_HOME:-/opt/anaconda3}"
if [[ -f "$CONDA_HOME/etc/profile.d/conda.sh" ]]; then
  conda() {
    unfunction conda
    source "$CONDA_HOME/etc/profile.d/conda.sh" || return
    conda "$@"
  }
fi
