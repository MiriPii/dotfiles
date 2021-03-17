#! zsh
export XDG_CACHE_HOME=${XDG_CACHE_HOME:=~/.cache}

# Export environment variables.
#export EDITOR=vim
#export GPG_TTY=$TTY
bindkey -e

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Extend PATH.
path=(~/bin $path)

###########################
# ZINIT installer chunk
###########################

typeset -A ZINIT
ZINIT_HOME=$XDG_CACHE_HOME/zsh/zinit
ZINIT[HOME_DIR]=$ZINIT_HOME
ZINIT[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zsh/zcompdump

### Added by Zinit's installer
if [[ ! -f $ZINIT_HOME/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$ZINIT_HOME" && command chmod g-rwX "$ZINIT_HOME"
    command git clone https://github.com/zdharma/zinit "$ZINIT_HOME/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source $ZINIT_HOME/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer chunk

# Functions to make configuration less verbose
# zt() : First argument is a wait time and suffix, ie "0a". Anything that doesn't match will be passed as if it were an ice mod. Default ices depth'3' and lucid
# zct(): First argument provides $MYPROMPT value used in load'' and unload'' ices. Sources a config file with tracking for easy unloading using $MYPROMPT value. Small hack to function in for-syntax
zt()  { zinit depth'3' lucid ${1/#[0-9][a-c]/wait"$1"} "${@:2}"; }
zct() {
    thmf="${ZINIT[PLUGINS_DIR]}/_local---config-files/themes"
    if [[ ${1} != ${MYPROMPT=p10k} ]] && { ___turbo=1; .zinit-ice \
    load"[[ \${MYPROMPT} = ${1} ]]" unload"[[ \${MYPROMPT} != ${1} ]]" }
    .zinit-ice atload'! [[ -f "${thmf}/${MYPROMPT}-post.zsh" ]] && source "${thmf}/${MYPROMPT}-post.zsh"' \
    nocd id-as"${1}-theme";
    ICE+=("${(kv)ZINIT_ICES[@]}"); ZINIT_ICES=();
}

# - - - - -
# THEME
# - - - - -

##################
# Initial Prompt #
#    Annexes     #
# Config source  #
##################

zt light-mode for \
    pick'async.zsh' \
        mafredri/zsh-async \
        romkatv/powerlevel10k \

zt light-mode compile'*handler' for \
        zinit-zsh/z-a-patch-dl \
        zinit-zsh/z-a-bin-gem-node \
        zinit-zsh/z-a-submods

## Add this if you want to create local plugins
##      see: https://github.com/zdharma/zinit-configs/tree/master/NICHOLAS85
#zt light-mode blockf for \
#        _local/config-files

#############
# PLUGINS
#############

zt atinit'HISTFILE="${HOME}/.histfile"' for \
    OMZL::history.zsh

######################
# Trigger-load block #
######################

zt light-mode for \
    trigger-load'!man' \
        ael-code/zsh-colored-man-pages \
    trigger-load'!gencomp' pick'zsh-completion-generator.plugin.zsh' blockf \
    atload'alias gencomp="zinit silent nocd as\"null\" wait\"2\" atload\"zinit creinstall -q _local/config-files; zicompinit\" for /dev/null; gencomp"' \
        RobSis/zsh-completion-generator

# ##################
# # Wait'0a' block #
# ##################

zt 0a light-mode for \
        OMZL::completion.zsh \
        OMZP::git \
        agkozak/zsh-z \
    if'false' ver'dev' \
        marlonrichert/zsh-autocomplete \
    has'systemctl' \
        OMZP::systemd/systemd.plugin.zsh \
        OMZP::sudo/sudo.plugin.zsh \
    blockf \
        zsh-users/zsh-completions
    compile'{src/*.zsh,src/strategies/*}' pick'zsh-autosuggestions.zsh' \
    atload'_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions

##################
# Wait'0b' block #
##################

zt 0b light-mode for \
    atinit'zpcompinit; zpcdreplay' atload'FAST_HIGHLIGHT[chroma-man]=' \
        zdharma/fast-syntax-highlighting \
    atload'bindkey "$terminfo[kcuu1]" history-substring-search-up;
    bindkey "$terminfo[kcud1]" history-substring-search-down' \
        zsh-users/zsh-history-substring-search \
    as'completion' mv'*.zsh -> _git' \
        felipec/git-completion

##################
# Wait'0c' block #
##################

zt 0c light-mode for \
    from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg" \
        BurntSushi/ripgrep

#    --- These Need to be fixed ---
#    atclone'PYENV_ROOT="$HOME/.pyenv" ./libexec/pyenv init - > zpyenv.zsh' \
#    atinit'export PYENV_ROOT="$PWD"' atpull'%atclone' \
#    as'command' pick'bin/pyenv' src'zpyenv.zsh' nocompile'!' \
#        pyenv/pyenv

zt 0c light-mode null for \
        supercrabtree/k \
    sbin"bin/git-dsf;bin/diff-so-fancy" \
        zdharma/zsh-diff-so-fancy \
    sbin \
        paulirish/git-open

#############
# HISTORY
#############
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zhistory"
HISTSIZE=290000
SAVEHIST=$HISTSIZE

#####################
# SETOPT            #
#####################
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_all_dups   # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data
setopt always_to_end          # when completing from the middle of a word, move the cursor to the end of the word

#####################
# P10K SETTINGS     #
#####################

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

##################
# ALIASES
##################

source $HOME/.zsh_aliases

##################
# KEYBINDS
##################

bindkey "^[[1;5C" forward-word      # [Ctrl-RightArrow] - move forward one word
bindkey "^[[1;5D" backward-word     # [Ctrl-LeftArrow]  - move backward one word
bindkey "^[[3;5~" kill-word         # [Ctrl+Del]        - delete next word
bindkey "^H" backward-kill-word     # [Ctrl+BackSpace]  - delete previous word

##########################
# CSC CentOS 7 - SCL sourcing
##########################

if [ "$HOSTNAME" = "dl5400-hztx33.x.csc.fi" ]; then
    source /opt/rh/rh-git218/enable         # Git-2.18
    source $HOME/.csc-env-vars
fi;

##########################
# PYENV - need moving to 0c-block
##########################

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi
