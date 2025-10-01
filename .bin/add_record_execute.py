#!/usr/bin/env python
import requests
import datetime
import json
import operator

def ask_bof():
    bof = input("你想要添加什么记录？(b)ook / (f)ilm / (s)eries  请输入：")
    return bof[0].lower()

def replace_bbk(string):
    new_st = string.replace(">!", "{{% bbk %}}").replace("!<", "{{% /bbk %}}")
    return new_st

def edit_data(fields, data):
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

def edit_book_data(data):
    fields = [
        ["书名", "title"],
        ["作者", "author"],
        ["出版年份", "public_year"],
        ["出版社", "press"],
        ["豆瓣", "link"],
        ["ISBN", "isbn"],
        ["时间", "mark_date"],
        ["打分", "my_score"],
        ["评价", "my_comment"],]
    return edit_data(fields, data)

def search_book_neodb(uuid, token):
    headers = {'Authorization': 'Bearer ' + token}
    data = {}

    item_url = 'https://neodb.social/api/book/' + uuid
    item_req = requests.get(item_url, headers = headers)
    item_j = item_req.json()
    # print(item_j)
    data["title"] = item_j.get("title", "null")
    data["author"] = " ".join(item_j.get("author", ["null"]))
    data["public_year"] = str(item_j.get("pub_year", "null"))
    data["press"] = str(item_j.get("pub_house", "null"))
    data["link"] = "null"
    ext_links = item_j.get("external_resources", [])
    for i in range(len(ext_links)):
        link = ext_links[i]["url"]
        if "douban" in link:
            data["link"] = link
    data["isbn"] = item_j.get("isbn", "null")

    mark_url = 'https://neodb.social/api/me/shelf/item/' + uuid
    mark_req = requests.get(mark_url, headers = headers)
    mark_j = mark_req.json()
    #print(mark_j)
    data["mark_date"] = mark_j.get("created_time", "null")
    data["my_score"] = "★" * (mark_j.get("rating_grade", 2) // 2)
    data["my_comment"] = replace_bbk(mark_j.get("comment_text", "null"))
    #print(data)

    return data


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
    return edit_data(fields, data)

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
    data["my_comment"] = replace_bbk(mark_j.get("comment_text", "null"))
    #print(data)

    return data

def search_tv_neodb(uuid, token):
    headers = {'Authorization': 'Bearer ' + token}
    data = {}

    item_url = 'https://neodb.social/api/tv/season/' + uuid
    item_req = requests.get(item_url, headers = headers)
    item_j = item_req.json()
    # print(item_j)
    data["title"] = item_j.get("title", "null")
    season_number = item_j.get("season_number", 0)
    if season_number == None or season_number <= 1:
        data["ori_name"] = item_j.get("orig_title", "null")
    else:
        data["ori_name"] = item_j.get("orig_title", "null") + " " + str(season_number)
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

    parent_uuid = item_j.get("parent_uuid", "null")
    if parent_uuid == "null" or parent_uuid == None:
        data["imdb_id"] = "null"
    else:
        tv_url = 'https://neodb.social/api/tv/' + parent_uuid
        tv_req = requests.get(tv_url, headers = headers)
        tv_j = tv_req.json()
        data["imdb_id"] = tv_j.get("imdb", "null")

    mark_url = 'https://neodb.social/api/me/shelf/item/' + uuid
    mark_req = requests.get(mark_url, headers = headers)
    mark_j = mark_req.json()
    #print(mark_j)
    data["mark_date"] = mark_j.get("created_time", "null")
    data["my_score"] = "★" * (mark_j.get("rating_grade", 2) // 2)
    data["my_comment"] = replace_bbk(mark_j.get("comment_text", "null"))
    #print(data)

    return data

def write_in(bof, data_dict):
    if bof == "b":
        add = "/home/orez/Blogs/blog/data/zh/book.json"
    elif bof == "f" or bof == "s":
        add = "/home/orez/Blogs/blog/data/zh/film.json"
    with open(add, 'r') as old_file:
        old_data = json.load(old_file)
    old_data.append(data_dict)
    old_data.sort(key = operator.itemgetter('mark_date'), reverse = True)
    with open (add, 'w') as new_file:
        json.dump(old_data, new_file, ensure_ascii=False, indent=2)

def get_token():
    fo = open("/home/orez/.bin/neodb_token", "r")
    line = fo.read()
    # print(line)
    fo.close()
    return line.strip()

def process():
    # token = input("请输入 neodb token：")
    token = get_token()
    bof = ask_bof()
    if bof == "b":
        key_word = input("请输入 UUID，或输入 n 手动录入：")
        if key_word == "n":
            data_dict = manualy_book()
        else:
            book_data = search_book_neodb(key_word, token)
            data_dict = edit_book_data(book_data)
    elif bof == "f":
        key_word = input("请输入 UUID，或输入 n 手动录入：")
        if key_word == "n":
            data_dict = manualy_film()
        else:
            film_data = search_film_neodb(key_word, token)
            data_dict = edit_film_data(film_data)
    elif bof == "s":
        key_word = input("请输入 UUID，或输入 n 手动录入：")
        if key_word == "n":
            data_dict = manualy_film()
        else:
            film_data = search_tv_neodb(key_word, token)
            data_dict = edit_film_data(film_data)
    else:
        print("error，请重新输入.")
        return 1
    write_in(bof, data_dict)
    go_next = input("是否继续增加记录：（[y]/n）")
    if go_next != "" and go_next[0].lower() == "n":
        return 0
    else:
        return 1

while 1:
    keep = process()
    if keep:
        continue
    else:
        break
