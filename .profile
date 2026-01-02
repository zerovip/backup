# export http_proxy=127.0.0.1:7897
# export https_proxy=127.0.0.1:7897
# export socks_proxy=127.0.0.1:7897
export all_proxy=socks5://127.0.0.1:7897

# 自动加载~/.bin到$PATH中
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi
