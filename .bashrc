lg() {
    git add .
    git commit -m "${1:-updates}"
    git push
}
