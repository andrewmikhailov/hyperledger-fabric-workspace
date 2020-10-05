# A reference to the suitable implementation
if [ ! -f shell.go ]; then
  ln -s ../shell-linux/shell.go
fi

# A reference to the shell evaluation pipeline script
if [ ! -f eval.sh ]; then
  ln -s ../shell-linux/eval.sh
fi

# MAC OS build
GOOS=darwin GOARCH=amd64 go build
