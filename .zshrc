# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ikasamak/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#### user setting start ####
# lang and alias
export LANG=en_US.UTF-8
alias v=vim
alias g=git
alias pl=perl
alias be='bundle exec'
alias ls='ls --group-directories-first --color'

# disable stop tty key-bind
stty stop undef

# mosh completion
compdef mosh=ssh

# mosh exit command
alias mxit='pkill -SIGUSR1 mosh-server'

# Third party completion
fpath=(~/.zsh/completion $fpath)

# Attach the last tmux session,
# or craete new session unless there is no last session.
if [ -z $TMUX ]; then
  if $(tmux has-session); then
    tmux attach
  else
    tmux
  fi
fi

# rbenv
if [ -d ~/.rbenv ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# gvm
[[ -s "/home/ikasamak/.gvm/scripts/gvm" ]] && source "/home/ikasamak/.gvm/scripts/gvm"

# awscli
export PATH=~/.local/bin:$PATH

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#### user setting end ####

#### zplug setting start ####
source ~/.zplug/init.zsh

# コマンドも管理する
# グロブを受け付ける（ブレースやワイルドカードなど）
zplug "Jxck/dotfiles", as:command, use:"bin/{histuniq,color}"

# 読み込み順序を設定する
# 例: "zsh-syntax-highlighting" は compinit の前に読み込まれる必要がある
# （2 以上は compinit 後に読み込まれるようになる）
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# ローカルプラグインも読み込める
zplug "~/.zsh", from:local

# https://github.com/mafredri/zsh-async
zplug "mafredri/zsh-async"

# テーマファイルを読み込む
zplug "yous/lime"
# zplug "sindresorhus/pure"
# zplug "denysdovhan/spaceship-zsh-theme"

export ENHANCD_FILTER=fzy:fzf:peco
zplug "b4b4r07/enhancd", use:init.sh

zplug "direnv/direnv", \
    as:command, \
    rename-to:direnv, \
    hook-build:"make"

# 未インストール項目をインストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load
#### zplug setting end ####

export EDITOR=vim
eval "$(direnv hook zsh)"
