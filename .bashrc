lg() {
    git add .
    git commit -m "${1:-updates}"
    git push
}

envdeps() {
    uv pip list --format json | python -c '
    import json
    import sys

    print("[project]")
    print("dependencies = [")
    packages = json.load(sys.stdin)
    for pkg in packages:
        print(f"""    "{pkg["name"]} = {pkg["version"]}" """)
    print("]")
    '
}