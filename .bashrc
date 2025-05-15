lg() {
    if [ -z "$1" ]; then
        echo "Error: Commit message is required"
        echo "Usage: lg \"your commit message\""
        return 1
    fi
    
    # Add all files and attempt to commit
    git add .
    git commit -m "$1"
    
    # If commit failed (non-zero exit code)
    if [ $? -ne 0 ]; then
        # Check if files were modified by hooks
        if git status --porcelain | grep -q '^ M'; then
            echo "Files were reformatted by hooks. Staging changes and retrying commit..."
            # Stage the modified files
            git add -u
            # Try committing again with the same message
            git commit -m "$1"
        fi
    fi
    
    # Push if commit was successful (either on first try or retry)
    if [ $? -eq 0 ]; then
        git push
    fi
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
