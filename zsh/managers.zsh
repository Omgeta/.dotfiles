# Load the default Node version so npm-installed commands are on PATH.
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
  [[ ! -s "$NVM_DIR/bash_completion" ]] || source "$NVM_DIR/bash_completion"
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
