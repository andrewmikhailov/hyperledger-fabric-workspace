for folder in */; do
  (
    cd "$folder"
    if [ -f ./build.sh ]; then
      ./build.sh
    fi
    cd ..
  )
done
