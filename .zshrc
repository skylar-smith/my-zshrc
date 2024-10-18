# .zshrc file
eval "$(starship init zsh)"

# Detect OS and set Homebrew environment accordingly
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

#Enable auto complete
autoload -Uz compinit
compinit


# General Aliases
alias ll='ls -lAFh --color=auto' # List files in long format with color
alias la='ls -A'                 # List all files including hidden files
alias l='ls -CF'                 # List files in column format
alias ..='cd ..'                 # Go up one directory
alias ...='cd ../../../'         # Go up three directories
alias ....='cd ../../../../'     # Go up four directories
alias grep='grep --color=auto'   # Grep with color enabled
alias fgrep='fgrep --color=auto' # Fixed-string grep with color
alias egrep='egrep --colorauto'  # Extended grep with color
alias docs='cd ~/Documents'      # Change directory to Documents
alias dwn='cd ~/Downloads'       # Change directory to Downloads
alias desk='cd ~/Desktop'        # Change directory to Desktop

# Git Aliases
alias gst='git status'           # Show the working tree status
alias gco='git checkout'         # Switch branches or restore files
alias gb='git branch'            # List, create, or delete branches
alias gc='git commit'            # Record changes to the repository
alias gca='git commit -a'        # Commit all changed files
alias gp='git push'              # Update remote refs with local refs
alias gpl='git pull'             # Fetch from and integrate with another repository
alias gad='git add .'            # Add all changes in the current directory to staging
alias gcm='git commit -m'        # Commit with a message
alias gd='git diff'              # Show changes between commits, commit and working tree, etc.
alias gl='git log'               # Show commit logs
alias gsh='git stash'            # Stash the changes in a dirty working directory
alias gshp='git stash pop'       # Apply stashed changes and then drop the stash
alias gcp='git cherry-pick'      # Apply the changes introduced by some existing commits
alias grm='git rebase master'    # Rebase the current branch on master
alias grc='git rebase --continue' # Continue the rebasing after a conflict resolution
alias gra='git remote add'       # Add a remote named <name>
alias grv='git remote -v'        # List all currently configured remotes
alias gcl='git clone'            # Clone a repository into a new directory

# Kubectl and things alias
alias k=kubectl
source <(kubectl completion zsh)
alias kc=kubectx
alias kn=kubens

#SDKMAN alias
alias j=". ~/my-zshrc/.j/j.sh" # Shorthand select java sdk
alias sdkswap=". ~/my-zshrc/.j/sdkswap.sh" # Fuzzy select sdk by version

# Function to extract various archives
extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.xz)    tar xvf $1     ;;
           *.tar.bz2)   tar xjf $1     ;;
           *.tar.gz)    tar xzf $1     ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar e $1     ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xf $1      ;;
           *.tbz2)      tar xjf $1     ;;
           *.tgz)       tar xzf $1     ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "'$1' cannot be extracted via extract()" ;;
       esac
   else
       echo "'$1' is not a valid file"
   fi
}

# Function to search for a pattern in files
search_files() {
    grep -rnw '.' -e "$1"
}

# Function to list all aliases with descriptions
list_aliases() {
    echo "Aliases and their descriptions:"
    grep '^alias' ~/.zshrc | cut -d'=' -f1 | while read -r line ; do
        alias_name=$(echo $line | cut -d' ' -f2)
        description=$(grep -P "^$line" ~/.zshrc | grep -oP '#.*')
        echo "$alias_name - ${description:2}"
    done
}

# Function to update .zshrc in my GitHub repository
update_zshrc_repo() {
    # Define the path to your repository
    local repo_path="$HOME/my-zshrc"

    # Copy the current .zshrc to the repository
    cp ~/.zshrc "$repo_path/.zshrc"

    # Change to the repository directory
    cd "$repo_path"

    # Add the .zshrc file to the git staging area
    git add .zshrc

    # Commit the change. The commit message includes the current date and time for reference
    git commit -m "Update .zshrc as of $(date +'%Y-%m-%d %H:%M:%S')"

    # Push the changes to GitHub
    git push origin main

    # Optionally, print a success message or return to the previous directory
    echo ".zshrc updated and pushed to GitHub on $(date)"
    cd -
}

# Enhanced directory colors (not needed for zsh, handled by zsh natively)

# Setting the default editor
export EDITOR='vim'

# SDKMAN setup
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

#PYENV
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"