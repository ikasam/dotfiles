# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#### user setting start ####
# lang and alias
export LANG=en_US.UTF-8

if [ $(command -v gls) ]; then
  alias ls='gls --group-directories-first --color=auto'
fi
alias ll='ls -l'
alias lla='ls -la'

alias v=vim
alias g=git
alias pl=perl
alias be='bundle exec'
alias reload='rm ~/.zcompdump && exec zsh -l'

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
if [ $(command -v tmux) ]; then
  if [ -z $TMUX ]; then
    if $(tmux has-session); then
      tmux attach
    else
      tmux
    fi
  fi
fi

# awscli
export PATH=~/.local/bin:$PATH

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#### user setting end ####

#### zplug setting start ####

export ZPLUG_HOME=~/.zplug

if [ ! -d $ZPLUG_HOME ]; then
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

if [ -d $ZPLUG_HOME ]; then
  source $ZPLUG_HOME/init.zsh

  if [ $(command -v fd) ]; then
    export FZF_DEFAULT_COMMAND='fd --type file --follow'
  fi
  
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
fi
#### zplug setting end ####

export EDITOR=vim
if [ $(command -v direnv) ]; then
  eval "$(direnv hook zsh)"
fi

