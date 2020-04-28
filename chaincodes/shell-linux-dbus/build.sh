# A reference to the suitable implementation
if [ ! -f start.tpl.sh ]; then
  ln -s ../shell-linux/start.tpl.sh
fi

# Linux build
GOOS=linux GOARCH=amd64 go build

mv shell-linux-dbus shell
