symlink() {
  OVERWRITTEN=""
  if [ -e "$2" ] || [ -h "$2" ]; then
    OVERWRITTEN="(Overwritten)"
    if ! rm -r "$2"; then
      substep_error "Failed to remove existing file(s) at $2."
    fi
  fi
  if ln -s "$1" "$2"; then
    substep_success "Symlinked $2 to $1. $OVERWRITTEN"
  else
    substep_error "Symlinking $2 to $1 failed."
  fi
}

color_echo() {
  local exp="$1";
  local color="$2";
  local arrow="$3";
  if ! [[ $color =~ '^[0-9]$' ]] ; then
    case $(echo $color | tr '[:upper:]' '[:lower:]') in
    black) color=0 ;;
    red) color=1 ;;
    green) color=2 ;;
    yellow) color=3 ;;
    blue) color=4 ;;
    magenta) color=5 ;;
    cyan) color=6 ;;
    white|*) color=7 ;; # white or invalid color
    esac
  fi
  tput setaf "$color";
  echo "$arrow $exp";
  tput sgr0;
}

info() {
  color_echo "$1" blue "::"
}

success() {
  color_echo "$1" green "✅"
}

success_final() {
  color_echo "$1" green "🎉"
}

error() {
  color_echo "$1" red "🔴"
}

substep_info() {
  color_echo "$1" blue ">"
}

substep_success() {
  color_echo "$1" cyan ">"
}

substep_error() {
  color_echo "$1" red ">"
}
