#!/usr/bin/env python
import requests
import urllib
import execjs  # 这个库是PyExecJS
import re
import datetime
from bs4 import BeautifulSoup
import json
import operator

username = ''
password = ''

def login_douban():
    headers = {
        'Referer': 'https://accounts.douban.com/passport/login_popup?login_source=anony',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36'
        }
    data = {
        'ck': '',
        'username': username,
        'password': password,
        'remember': 'false',
        'ticket': ''
        }
    login_url = 'https://accounts.douban.com/j/mobile/login/basic'
    try:
        html = requests.Session().post(url = login_url, headers = headers, data = data).content.decode('utf-8')
        print(html)
    except Exception as e:
        print(e)

def search_douban(t, key_word):
    if t == "movie":
        t_n = "2"
    elif t == "book":
        t_n = "1"
    url = "https://search.douban.com/" + t + "/subject_search?search_text=" + key_word + "&cat=100" + t_n
    header = {
            'user-agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0',
            'Referer': url,
            'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'accept-language': 'zh-CN,en-US;q=0.5',
            'connection': 'keep-alive',
            'Host': 'search.douban.com',
            }
    html = requests.Session().get(url, headers = header).content.decode('utf-8')
    # 以下内容来自：https://github.com/SergioJune/Spider-Crack-JS
    # 原理见：https://mp.weixin.qq.com/s/-CkjMbhuooKm3U4GKIfEPg
    r = re.search('window.__DATA__ = "([^"]+)"', html).group(1)
    # 导入js
    with open('main.js', 'r', encoding='gbk') as f:
        decrypt_js = f.read()
    ctx = execjs.compile(decrypt_js)
    data = ctx.call('decrypt', r)
    return data['payload']['items'][0]['url']

def ask_bof():
    bof = input("你想要添加什么记录？(b)ook / (f)ilm  请输入：")
    return bof[0].lower()

def manualy_book():
    title = input("请输入书名：")
    author = input("请输入作者（[国家] 名字·姓）：")
    public_year = input("请输入出版年份：")
    press = input("请输入出版社：")
    link = input("请输入豆瓣链接，没有请留空：")
    isbn = input("请输入 ISBN：")
    mark_date = input("请输入标记日期，今天请输入 t：")
    if mark_date == "t":
        mark_date = str(datetime.date.today())
    my_score_n = input("请输入评分，1-5 之间的整数：")
    my_score = "★" * int(my_score_n)
    my_comment = input("请输入点评：")
    book_dict = {
            'title': title,
            'author': author,
            'public_year': public_year,
            'press': press,
            'link': link,
            'mark_date': mark_date,
            'my_score': my_score,
            'my_comment': my_comment
            }
    return book_dict

def manualy_film():
    title = input("请输入电影名：")
    ori_name = input("请输入电影原名，如果和电影名相同输入 s：")
    if ori_name == "s":
        ori_name = title
    public_year = input("请输入发行年份：")
    produce_country = input("请输入发行国家：")
    film_type = input("请输入电影类型，用空格隔开：")
    director = input("请输入导演（名·姓）：")
    link = input("请输入豆瓣链接，没有请留空：")
    imdb_id = input("请输入 imdb 编号，以 tt 开头：")
    mark_date = input("请输入标记日期，今天请输入 t：")
    if mark_date == "t":
        mark_date = str(datetime.date.today())
    my_score_n = input("请输入评分，1-5 之间的整数：")
    my_score = "★" * int(my_score_n)
    my_comment = input("请输入点评：")
    film_dict = {
            'title': title,
            'ori_name': ori_name,
            'public_year': public_year,
            'produce_country': produce_country,
            'film_type': film_type,
            'director': director,
            'link': link,
            'imdb_id': imdb_id,
            'mark_date': mark_date,
            'my_score': my_score,
            'my_comment': my_comment
            }
    return film_dict

def get_message_book(link):
    header = {
            'user-agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0',
            'Referer': 'https://book.douban.com/',
            'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'accept-language': 'zh-CN,en-US;q=0.5',
            'connection': 'keep-alive',
            'Host': 'book.douban.com',
            }
    html = requests.Session().get(link, headers = header).content.decode('utf-8')
    soup = BeautifulSoup(html, features="html.parser")
    info1 = soup.h1.get_text()
    print(info1)
    title = re.sub('\s|\t|\n', '', info1)
    info2 = soup.find("div", {"id": "info"}).get_text()
    print(info2)
    author = re.sub('\s|\t|\n', '', re.search(r'^((.|\n)*)\n' ,re.search(r'作者:((.|\n)*?):', info2).group(1)).group(1))
    public_year = re.findall(r'出版年: (.*?)\n', info2)[0][0:4]
    press = re.findall(r'出版社: (.*?)\n', info2)[0]
    link = link
    title_input = input("获取到的书名是：" + title + "，回车确认，输入更改：")
    if title_input != "":
        title = title_input
    author_input = input("获取到的作者是：" + author + "，回车确认，输入更改：")
    if author_input != "":
        author = author_input
    public_year_input = input("获取到的出版时间是：" + public_year + "，回车确认，输入更改：")
    if public_year_input != "":
        public_year = public_year_input
    press_input = input("获取到的出版社是：" + press + "，回车确认，输入更改：")
    if press_input != "":
        press = press_input
    link_input = input("获取到的链接是：" + link + "，回车确认，输入更改：")
    if link_input != "":
        link = link_input
    mark_date = input("请输入标记日期，今天请输入 t：")
    if mark_date == "t":
        mark_date = str(datetime.date.today())
    my_score_n = input("请输入评分，1-5 之间的整数：")
    my_score = "★" * int(my_score_n)
    my_comment = input("请输入点评：")
    book_dict = {
            'title': title,
            'author': author,
            'public_year': public_year,
            'press': press,
            'link': link,
            'mark_date': mark_date,
            'my_score': my_score,
            'my_comment': my_comment
            }
    return book_dict

def get_message_film(link):
    header = {
            'user-agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0',
            'Referer': 'https://movie.douban.com/',
            'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'accept-language': 'zh-CN,en-US;q=0.5',
            'connection': 'keep-alive',
            'Host': 'movie.douban.com',
            }
    html = requests.Session().get(link, headers = header).content.decode('utf-8')
    soup = BeautifulSoup(html, features="html.parser")
    info1 = soup.h1.get_text()
    print(info1)
    title_ori = re.search(r'(.*?) (.*)', info1)
    title = title_ori.group(1)
    ori_name = title_ori.group(2)
    public_year = re.findall(r'[(]([0-9]{4})[)]', info1)[0]
    info2 = soup.find("div", {"id": "info"}).get_text()
    print(info2)
    director = re.findall(r'导演: (.*?)\n', info2)[0]
    produce_country = re.findall(r'制片国家/地区: (.*?)\n', info2)[0].replace(" / ", " ")
    film_type = re.findall(r'类型: (.*?)\n', info2)[0].replace(" / ", " ")
    link = link
    imdb_id = re.findall(r'IMDb: (tt.*)', info2)[0]
    title_input = input("获取到的电影名字是：" + title + "，回车确认，输入更改：")
    if title_input != "":
        title = title_input
    ori_name_input = input("获取到的电影原名是：" + ori_name + "，回车确认，输入更改：")
    if ori_name_input != "":
        ori_name = ori_name_input
    public_year_input = input("获取到的发行时间是：" + public_year + "，回车确认，输入更改：")
    if public_year_input != "":
        public_year = public_year_input
    produce_country_input = input("获取到的制作地区是：" + produce_country + "，回车确认，输入更改：")
    if produce_country_input != "":
        produce_country = produce_country_input
    film_type_input = input("获取到的电影类型是：" + film_type + "，回车确认，输入更改：")
    if film_type_input != "":
        film_type = film_type_input
    director_input = input("获取到的导演是：" + director + "，回车确认，输入更改：")
    if director_input != "":
        director = director_input
    link_input = input("获取到的链接是：" + link + "，回车确认，输入更改：")
    if link_input != "":
        link = link_input
    imdb_id_input = input("获取到的 IMDB 编号是：" + imdb_id + "，回车确认，输入更改：")
    if imdb_id_input != "":
        imdb_id = imdb_id_input
    mark_date = input("请输入标记日期，今天请输入 t：")
    if mark_date == "t":
        mark_date = str(datetime.date.today())
    my_score_n = input("请输入评分，1-5 之间的整数：")
    my_score = "★" * int(my_score_n)
    my_comment = input("请输入点评：")
    film_dict = {
            'title': title,
            'ori_name': ori_name,
            'public_year': public_year,
            'produce_country': produce_country,
            'film_type': film_type,
            'director': director,
            'link': link,
            'imdb_id': imdb_id,
            'mark_date': mark_date,
            'my_score': my_score,
            'my_comment': my_comment
            }
    return film_dict

def write_in(bof, data_dict):
    if bof == "b":
        add = "/home/ehizil/codes/blog/data/zh/book.json"
    elif bof == "f":
        add = "/home/ehizil/codes/blog/data/zh/film.json"
    with open(add, 'r') as old_file:
        old_data = json.load(old_file)
    old_data.append(data_dict)
    old_data.sort(key = operator.itemgetter('mark_date'), reverse = True)
    with open (add, 'w') as new_file:
        json.dump(old_data, new_file, ensure_ascii=False, indent=2)

def process():
    # login_douban()
    bof = ask_bof()
    if bof == "b":
        key_word = input("请输入 ISBN 号自动查找，或输入 n 手动录入：")
        if key_word == "n":
            data_dict = manualy_book()
        else:
            book_link = search_douban("book", key_word)
            data_dict = get_message_book(book_link)
    elif bof == "f":
        key_word = input("请输入 IMDB 号（以 tt 开头）自动查找，或输入 n 手动录入：")
        if key_word == "n":
            data_dict = manualy_film()
        else:
            film_link = search_douban("movie", key_word)
            data_dict = get_message_film(film_link)
    else:
        print("error，请重新输入.")
        return 1
    write_in(bof, data_dict)
    return 0

while 1:
    keep = process()
    if keep:
        continue
    else:
        break
