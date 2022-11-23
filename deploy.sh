#!/bin/bash

cd ~/codes/blog

echo -e "【 博客的部署脚本开始启动啦！ 】"
echo -e "【 \033[0;32mDeploying updates to GitHub...\033[0m 】"

# Build the project.
hugo --gc --minify # if using a theme, replace with `hugo -t <YOURTHEME>`
# 进行加密
echo -e "【 下面是加密内容 】"
./hugo-encrypt -sitePath ./public
echo -e "【 加密内容结束 】"
echo -e "【 下面是 Pagefind 建立索引 】"
./pagefind_extended
echo -e "【 Pagefind 建立索引结束 】"

# Go To Public folder
cd public
if [[ `git status --porcelain --untracked-files=no` ]]; then
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
elif check_git | grep -q 'Need to push'; then
    # Push source and build repos.
    git push origin master

    # Come Back up to the Project Root
    cd ..
else
    echo "没有变化，无需部署！"
    cd ..
fi
