# Copy to clipboard
copy() {
  if [ -e "$1" ]; then
    cat "$1" | pbcopy
    echo "Contents of $1 copied to clipboard."
  else
    echo "File $1 does not exist."
  fi
}

# https://react.doctor
react-doctor() {
  bunx react-doctor@latest $1
}
