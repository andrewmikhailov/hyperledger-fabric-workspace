# This installs the cross-compiler:
# sudo apt-get install gcc-arm*

# TODO: install the Android NDK

# A reference to the shell evaluation pipeline script
if [ ! -f eval.sh ]; then
  ln -s ../shell-linux/eval.sh
fi

# Android build
# GOOS=android GOARCH=arm CGO_ENABLED=1 CC=arm-linux-gnueabi-gcc go build
