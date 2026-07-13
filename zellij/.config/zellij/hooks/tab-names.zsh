[[ -n ${ZSH_VERSION:-} ]] || return 0
(( $+commands[zsh] && $+commands[zellij] )) || return 0

autoload -Uz add-zsh-hook

_zellij_tab_command_name() {
  emulate -L zsh

  local token
  local -a words
  local -i index=1

  words=(${(z)1}) || return 1

  while (( index <= ${#words} )); do
    token=${(Q)words[index]}

    if [[ $token =~ '^[A-Za-z_][A-Za-z0-9_]*=' ]]; then
      (( index++ ))
      continue
    fi

    case $token in
      command|builtin|exec|noglob|time)
        (( index++ ))
        while (( index <= ${#words} )) && [[ ${(Q)words[index]} == -* ]]; do
          (( index++ ))
        done
        ;;
      env)
        (( index++ ))
        while (( index <= ${#words} )); do
          token=${(Q)words[index]}
          if [[ $token == -u || $token == --unset || $token == -C || $token == --chdir ]]; then
            (( index += 2 ))
          elif [[ $token == -* || $token =~ '^[A-Za-z_][A-Za-z0-9_]*=' ]]; then
            (( index++ ))
          else
            break
          fi
        done
        ;;
      sudo)
        (( index++ ))
        while (( index <= ${#words} )); do
          token=${(Q)words[index]}
          if [[ $token == -u || $token == --user || $token == -g || $token == --group ||
                $token == -h || $token == --host || $token == -p || $token == --prompt ||
                $token == -C || $token == --close-from || $token == -R || $token == --chroot ||
                $token == -D || $token == --chdir ]]; then
            (( index += 2 ))
          elif [[ $token == -* ]]; then
            (( index++ ))
          else
            break
          fi
        done
        ;;
      *)
        token=${token:t}
        token=${token//[^A-Za-z0-9_.-]/-}
        [[ -n $token ]] || return 1
        print -r -- ${token[1,32]}
        return 0
        ;;
    esac
  done

  return 1
}

_zellij_rename_tab() {
  [[ -n $ZELLIJ && -n $commands[zellij] ]] || return 0
  command zellij action rename-tab -- "$1" >/dev/null 2>&1
}

_zellij_tab_precmd() {
  _zellij_rename_tab zsh
}

_zellij_tab_preexec() {
  local tab_name

  tab_name=$(_zellij_tab_command_name "${2:-$1}") || return 0
  _zellij_rename_tab "$tab_name"
}

add-zsh-hook -d precmd _zellij_tab_precmd 2>/dev/null
add-zsh-hook -d preexec _zellij_tab_preexec 2>/dev/null
add-zsh-hook precmd _zellij_tab_precmd
add-zsh-hook preexec _zellij_tab_preexec
