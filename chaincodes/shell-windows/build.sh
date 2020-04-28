# A reference to the suitable implementation
if [ ! -f shell.go ]; then
  ln -s ../shell-linux/shell.go
fi

# MAC OS build
GOOS=windows GOARCH=386 go build

mv shell-windows.exe shell.exe
