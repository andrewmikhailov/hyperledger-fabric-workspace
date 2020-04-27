for folder in */; do
  (
    cd "$folder"
    ./build.sh
    cd ..
  )
done
