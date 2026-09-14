#!/usr/bin/env zsh
# gentle-switch — alterna el binario gentle-ai activo entre main (brew) y RC (go install).
# Se ejecuta vía alias con `source` para aplicar el cambio en la shell actual.
# Único output: la versión que queda activa.

gentle_switch() {
  local BASE="$HOME/.local/bin/gentle-ai"
  local PATHS_FILE="$HOME/.config/.zsh/paths.zsh"
  local MAIN_SRC="/home/linuxbrew/.linuxbrew/bin/gentle-ai"
  local RC_SRC="$HOME/go/bin/gentle-ai"
  local MAIN_DIR="$BASE/gentle-ai"
  local RC_DIR="$BASE/gentle-ai-rc"

  # 1. Verificar que los folders estén correctamente posicionados; si no, regenerar el symlink
  local dir src
  for dir src in "$MAIN_DIR" "$MAIN_SRC" "$RC_DIR" "$RC_SRC"; do
    if [[ ! -x "$src" ]]; then
      print -u2 "gentle-switch: el binario origen no existe: $src"
      return 1
    fi
    mkdir -p "$dir"
    if [[ ! -L "$dir/gentle-ai" ]] || [[ "$(readlink "$dir/gentle-ai")" != "$src" ]] || [[ ! -x "$dir/gentle-ai" ]]; then
      ln -sfn "$src" "$dir/gentle-ai"
    fi
  done

  # 2. Estado actual: se lee del archivo (parseo), no se recuerda
  local lines=("${(@f)$(grep -n '^export GENTLE_PATH=' "$PATHS_FILE" 2>/dev/null)}")
  if (( ${#lines} == 0 )); then
    print -u2 "gentle-switch: no encuentro 'export GENTLE_PATH=' en $PATHS_FILE"
    return 1
  fi
  local lineno="${lines[-1]%%:*}"
  local current="${lines[-1]#*=}"
  current="${current#\"}"; current="${current%\"}"
  current="${(e)current}"

  # 3. Toggle al otro binario
  local new
  if [[ "$current" == "$MAIN_DIR" ]]; then
    new="$RC_DIR"
  elif [[ "$current" == "$RC_DIR" ]]; then
    new="$MAIN_DIR"
  else
    print -u2 "gentle-switch: valor GENTLE_PATH desconocido: $current"
    return 1
  fi

  # 4. Editar la línea correspondiente del archivo
  local replacement="export GENTLE_PATH=\"\$HOME/.local/bin/gentle-ai/${new:t}\""
  sed -i "${lineno}s|^export GENTLE_PATH=.*|${replacement}|" "$PATHS_FILE" || return 1

  # 5. Aplicar en la shell actual
  export GENTLE_PATH="$new"
  export PATH="$GENTLE_PATH:$PATH"
  typeset -U PATH path
  rehash

  # 6. Único output: versión activa
  "$GENTLE_PATH/gentle-ai" version
}

gentle_switch "$@"
