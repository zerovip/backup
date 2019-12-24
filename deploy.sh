#!/bin/bash

cd ~/codes/blog

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"
echo -e "脚本开始启动啦！"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`
# 进行加密
source ~/codes/hugo_encryptor/hugo-encryptor/bin/activate
python hugo-encryptor
deactivate

# Go To Public folder
cd public
# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..
