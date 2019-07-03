# v.1.0
# tail -f $1 | sh > $2 &

# v.2.0
# cat $1 | sh > $2 &

# v.3.0
inotifywait -r -m -e modify $1 |
    while read path _ file; do 
    	cat $path$file | sh > $2 &
    done
