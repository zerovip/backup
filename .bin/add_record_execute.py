#!/usr/bin/env python
import requests
import urllib3
import execjs  # 这个库是PyExecJS
import re
import datetime
from bs4 import BeautifulSoup
import json
import operator

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
    mark_date = input("请输入标记日期，今天请回车：")
    if mark_date == "":
        mark_date = str(datetime.date.today())
    else:
        date_list = mark_date.replace('/','-').split('-')
        mark_date = str(datetime.date(int(date_list[0]), int(date_list[1]), int(date_list[2])))
    my_score_n = input("请输入评分，1-5 之间的整数：")
    my_score = "★" * int(my_score_n)
    my_comment = input("请输入点评：")
    book_dict = {
            'title': title,
            'author': author,
            'public_year': public_year,
            'press': press,
            'link': link,
            'isbn': isbn,
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
    mark_date = input("请输入标记日期，今天请回车：")
    if mark_date == "":
        mark_date = str(datetime.date.today())
    else:
        date_list = mark_date.replace('/','-').split('-')
        mark_date = str(datetime.date(int(date_list[0]), int(date_list[1]), int(date_list[2])))
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
    title = re.sub(r'\s|\t|\n', '', info1)
    info2 = soup.find("div", {"id": "info"}).get_text()
    print(info2)
    author = re.sub(r'\s|\t|\n', '', re.search(r'^((.|\n)*)\n' ,re.search(r'作者:((.|\n)*?):', info2).group(1)).group(1))
    public_year = re.findall(r'出版年: (.*?)\n', info2)[0][0:4]
    press = re.findall(r'出版社: (.*?)\n', info2)[0]
    link = link
    isbn = re.findall(r'ISBN: (.*?)\n', info2)[0]
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
    isbn_input = input("获取到的 ISBN 是：" + isbn + "，回车确认，输入更改：")
    if isbn_input != "":
        isbn = isbn_input
    mark_date = input("请输入标记日期，今天请回车：")
    if mark_date == "":
        mark_date = str(datetime.date.today())
    else:
        date_list = mark_date.replace('/','-').split('-')
        mark_date = str(datetime.date(int(date_list[0]), int(date_list[1]), int(date_list[2])))
    my_score_n = input("请输入评分，1-5 之间的整数：")
    my_score = "★" * int(my_score_n)
    my_comment = input("请输入点评：")
    book_dict = {
            'title': title,
            'author': author,
            'public_year': public_year,
            'press': press,
            'link': link,
            'isbn': isbn,
            'mark_date': mark_date,
            'my_score': my_score,
            'my_comment': my_comment
            }
    return book_dict

def edit_film_data(data):
    fields = [
        ["标题", "title"],
        ["原名", "ori_name"],
        ["年份", "public_year"],
        ["地区", "produce_country"],
        ["类型", "film_type"],
        ["导演", "director"],
        ["豆瓣", "link"],
        ["imdb", "imdb_id"],
        ["时间", "mark_date"],
        ["打分", "my_score"],
        ["评价", "my_comment"],]
    while 1:
        for i in range(len(fields)):
            print("    ", str(i + 1), ". ", fields[i][0], ": [", data[fields[i][1]], "]")
        oper = input("是否保存？输入 s 保存，输入数字更改：")
        if oper == "s":
            return data
        if int(oper) >= 1 and int(oper) <= len(fields):
            index = int(oper) - 1
            new_data = input("要修改 " + str(index + 1) + ". " + fields[index][0] + ": [" + data[fields[index][1]] + "]，改为：（不修改直接回车）")
            if new_data == "":
                print("未修改，请再检查！")
                continue
            else:
                data[fields[index][1]] = new_data
                print("已修改，请再检查！")
                continue
        print("输入有误，请重新输入！")

def search_film_neodb(uuid, token):
    headers = {'Authorization': 'Bearer ' + token}
    data = {}

    item_url = 'https://neodb.social/api/movie/' + uuid
    item_req = requests.get(item_url, headers = headers)
    item_j = item_req.json()
    # print(item_j)
    data["title"] = item_j.get("title", "null")
    data["ori_name"] = item_j.get("orig_title", "null")
    data["public_year"] = str(item_j.get("year", "null"))
    data["produce_country"] = " ".join(item_j.get("area", ["null"]))
    data["film_type"] = " ".join(item_j.get("genre", ["null"]))
    data["director"] = " ".join(item_j.get("director", ["null"]))
    data["link"] = "null"
    ext_links = item_j.get("external_resources", [])
    for i in range(len(ext_links)):
        link = ext_links[i]["url"]
        if "douban" in link:
            data["link"] = link
    data["imdb_id"] = item_j.get("imdb", "null")

    mark_url = 'https://neodb.social/api/me/shelf/item/' + uuid
    mark_req = requests.get(mark_url, headers = headers)
    mark_j = mark_req.json()
    #print(mark_j)
    data["mark_date"] = mark_j.get("created_time", "null")
    data["my_score"] = "★" * (mark_j.get("rating_grade", 2) // 2)
    data["my_comment"] = mark_j.get("comment_text", "null")
    #print(data)

    return data

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

def get_token():
    fo = open("/home/ehizil/.bin/neodb_token", "r")
    line = fo.read()
    # print(line)
    fo.close()
    return line.strip()

def process():
    # token = input("请输入 neodb token：")
    token = get_token()
    bof = ask_bof()
    if bof == "b":
        key_word = input("请输入 ISBN 号自动查找，或输入 n 手动录入：")
        if key_word == "n":
            data_dict = manualy_book()
        else:
            book_json = search_neodb(key_word, token)
            data_dict = get_message_book(book_json)
    elif bof == "f":
        key_word = input("请输入 UUID，或输入 n 手动录入：")
        if key_word == "n":
            data_dict = manualy_film()
        else:
            film_data = search_film_neodb(key_word, token)
            data_dict = edit_film_data(film_data)
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
