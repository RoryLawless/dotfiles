if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -gx EDITOR nano

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
set -gx MAMBA_EXE "/opt/homebrew/opt/micromamba/bin/micromamba"
set -gx MAMBA_ROOT_PREFIX "/Users/rory/micromamba"
$MAMBA_EXE shell hook --shell fish --root-prefix $MAMBA_ROOT_PREFIX | source
# <<< mamba initialize <<<
