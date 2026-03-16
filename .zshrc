if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

HOMEBREW_PREFIX="$(brew --prefix 2>/dev/null)"

if [[ -n "$HOMEBREW_PREFIX" && -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [[ -n "$HOMEBREW_PREFIX" && -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=42'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=42'
ZSH_HIGHLIGHT_STYLES[function]='fg=42'
ZSH_HIGHLIGHT_STYLES[alias]='fg=42'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=42'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=42'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=42'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=167'

export CLICOLOR=1
export LSCOLORS='Exfxcxdxbxegedabagacad'
alias ls='ls -G'

PROMPT='(%F{75}%n@%m%f)-[%F{42}%~%f] %# '

if [[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/opt/openjdk" ]]; then
  export JAVA_HOME="$HOMEBREW_PREFIX/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
  export PATH="$JAVA_HOME/bin:$PATH"
fi
