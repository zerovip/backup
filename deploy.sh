#!/bin/bash

cd ~/codes/blog

echo -e "【 博客的部署脚本开始启动啦！ 】"
echo -e "【 \033[0;32mDeploying updates to GitHub...\033[0m 】"

# Build the project.
hugo --gc --minify # if using a theme, replace with `hugo -t <YOURTHEME>`
# 进行加密
echo -e "【 下面是加密内容 】"
source ~/codes/hugo_encryptor_venv/bin/activate
#----------------------------------------------
# cd ~/codes/hugo_encryptor
# vim requirements.txt # 把 pip 安装的包的版本号掉，以免不兼容
# pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
# 这里 pip 不是系统变量，而是进了 venv 环境以后才有的命令
#----------------------------------------------
python ~/codes/hugo_encryptor/hugo-encryptor.py
# 这里全都改成使用绝对路径了
# 这样一来，从 github 上 clone 下来 hugo-encryptor 的库之后，
#   什么都不用做，这个脚本就是 ok 的.
deactivate
echo -e "【 加密内容结束 】"

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
