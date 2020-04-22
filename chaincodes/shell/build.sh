# Linux build
GOOS=linux GOARCH=amd64 go build
mv shell shell-linux-amd64

# MAC OS build
# GOOS=darwin GOARCH=amd64 go build
# mv shell shell-darwin-amd64

# Windows build
# GOOS=windows GOARCH=amd64 go build
# mv shell shell-windows-amd64

# Android build
GOOS=android GOARCH=arm go build
mv shell shell-android-arm
