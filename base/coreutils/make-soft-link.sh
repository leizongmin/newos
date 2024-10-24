#/bin/sh

make_link() {
    cd $1
    ln -s coreutils $2
}

while IFS= read -r line; do
    if [ -n "$line" ]; then
        make_link $1 $line
    fi
done < commands.txt
