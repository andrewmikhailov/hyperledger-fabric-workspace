# A reference to the suitable implementation
if [ ! -f start.tpl.sh ]; then
  ln -s ../shell-linux/start.tpl.sh
fi

# A reference to the shell evaluation pipeline script
if [ ! -f eval.sh ]; then
  ln -s ../shell-linux/eval.sh
fi

# Linux build
GOOS=linux GOARCH=amd64 go build
