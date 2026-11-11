# This installs the cross-compiler:
# sudo apt-get install gcc-arm*

# TODO: install the Android NDK

# Android build
GOOS=android GOARCH=arm CGO_ENABLED=1 CC=arm-linux-gnueabi-gcc go build
