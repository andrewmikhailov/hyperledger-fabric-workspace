# A reference to the suitable implementation
if [ ! -f shell.go ]; then
  ln -s ../shell-linux/shell.go
fi

# MAC OS build
GOOS=darwin GOARCH=amd64 go build
