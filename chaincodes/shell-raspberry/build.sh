# A reference to the suitable implementation
if [ ! -f shell.go ]; then
  ln -s ../shell-linux/shell.go
fi

# MAC OS build
GOOS=linux GOARCH=arm GOARM=5 go build
