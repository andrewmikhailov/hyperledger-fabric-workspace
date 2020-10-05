# A reference to the suitable implementation
if [ ! -f shell.go ]; then
  ln -s ../shell-linux/shell.go
fi

# A reference to the shell evaluation pipeline script
if [ ! -f eval.sh ]; then
  ln -s ../shell-linux/eval.sh
fi

# Raspberry Pi build
GOOS=linux GOARCH=arm GOARM=5 go build
