
function config
    # This is a wrapper function around git commands that refer to a bare repository in the home directory
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME/ $argv
end