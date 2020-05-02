# !/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
rm -r public
rm -r ../anantd.github.io 
cp -r public/* ../anantd.github.io/
cp deploy.sh ../anantd.github.io

# Add changes to git.
# git add -A

# Commit changes.
#msg="rebuilding site $(date)"
#if [ -n "$*" ]; then
#	msg="$*"
#fi
#git commit -m "$msg"

# Push source and build repos.
#git push
