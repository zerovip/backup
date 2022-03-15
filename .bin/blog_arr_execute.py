#!/usr/bin/env python

import fileinput
import datetime
import os

tip = """
    这个工具是为了整理博客的文件夹组织结构，
    里面只涉及日期、url、标题，当然分类也是其中的一部分。
    其他内容如隐藏、加密、摘要等都不是这个工具的责任。
    """

print(tip)

f_m = """---
#------------------------------------------------------------------------------
# <main_title>[ - <column>]
# 对于语言表达法：<title> ::= english_word
# <column> ::= 21 世纪的定理 | 消费指南 | 语言表达法 | 巴别塔 | 自写主题
title: {title}
#------------------------------------------------------------------------------
# 一串数字即可，如果以0开头就用双引号引起来
url: {url}
#------------------------------------------------------------------------------
# 必须五选一：notes, stories, journal, literature, memos, 是为了显示文章时左侧位置还在
section: {section_name}
#------------------------------------------------------------------------------
# 栏目名称，目前可选：21cen, buy, language, babel, hugo
# 注意：秘密文章不要写这一项
# 注意：含有 notes 的文章不要组成 column，即 file_path 不为空的文章请保证这一项为空
column:
#------------------------------------------------------------------------------
date: {date}
#------------------------------------------------------------------------------
# 对于语言表达法：<explain>——<main_title>
summary:
#------------------------------------------------------------------------------
weight:
#------------------------------------------------------------------------------
# 可选 pandoc 以使用它来生成数学类文章
markup:
#------------------------------------------------------------------------------
# 若要秘密文章不予显示，下面两个改为 true 即可
#------------------------------------------------------------------------------
# list_hide 是在列表中隐藏
list_hide: false
#------------------------------------------------------------------------------
# rss_hide 是在 rss 中隐藏，有【加密内容】的博客这个必须为 true
rss_hide: false
#------------------------------------------------------------------------------
# 直接 文件名 即可，如 xxx.pdf
# 放到和 index.md 相同的文件夹下，渲染数学类文章的 pdf
file_path:
#------------------------------------------------------------------------------
# 是草稿吗？true / false
draft: true
#------------------------------------------------------------------------------
# 不要目录吗？true 则不生成目录.
no_toc: false
#------------------------------------------------------------------------------
# 一些有用的 snippets：
#   黑块    bbk：{{% bbk %}}text{{% /bbk %}}
#   背景色  bjj：{{% notice "sentence" %}}text{{% /notice %}}
#   背景段  bjd：{{% notice "paragraph" %}}text{{% /notice %}}
#   图片    img：![示例图片](example.jpeg)
#   如果图片需要在暗色主题下反色，请命名成 example.i.png|jpg|jpeg|gif|…
#   加密环境  jmhj
#------------------------------------------------------------------------------
---

"""

url_file = '/home/ehizil/codes/blog/url'
# url_e_file = '~/codes/blog/url_for_encryptor'

def ask_purpose():
    p = input("你想要做什么？（a：添加文章；e：修改文章）  ")
    return p

def add_post():
    section = input("请输入分区（1 数学笔记；2 数学科普；3 日志；4 写作；5 备忘）：")
    base = "/home/ehizil/codes/blog"
    if section == "1":
        path = base + "/content/math/notes"
        section_name = "notes"
    elif section == "2":
        path = base + "/content/math/stories"
        section_name = "stories"
    elif section == "3":
        path = base + "/content/non-math/journal"
        section_name = "journal"
    elif section == "4":
        path = base + "/content/non-math/literature"
        section_name = "literature"
    elif section == "5":
        path = base + "/content/non-math/memos"
        section_name = "memos"
    else:
        print("输入有误！")
        return 0
    title = input("请输入文章标题：")
    date = input("请输入日期（格式 yyyy-mm-dd，今天直接回车）：")
    url = ""
    if date == "":
        date = str(datetime.date.today())
    date_dot = date.replace("-", ".").strip()
    already = 0
    for line in fileinput.input(url_file, inplace=True):
        if (already == 1) or (fileinput.filelineno() == 1) or ('----' in line):
            print(line, end='')
        else:
            url = line.strip()
            print('{}{}'.format(line.strip(), '----' + title))
            already = 1
    if url == "":
        print("未获取到 url！请检查！")
        return 0
    dir_path = path + "/" + date_dot + " - " + url + " - " + title.strip()
    os.mkdir(dir_path)
    with open(dir_path + "/index.md", "w") as f:
        f.write(f_m.format(title = title, url = url, section_name = section_name, date = date))

def edit_post():
    with open(url_file) as uf:
        print("")
        for line in uf:
            if (len(line) >= 5) and ("----" in line):
                print(line.strip())
    print("")
    obj = input("你想要修改的文章是：（输入 url 序号）")
    print("该功能尚未完成！")
    # 修改文章标题（url 文件、文件夹结构、fm）、修改分区（文件夹结构、fm）、修改日期（文件夹名、fm）

def process():
    p = ask_purpose()
    if p == 'a':
        # 添加文章的逻辑
        add_post()
    elif p == 'e':
        # 编辑文章的逻辑
        edit_post()
    else:
        print("输入错误，请重新输入.")
        return 1
    return 0

while 1:
    keep = process()
    if keep:
        continue
    else:
        break
