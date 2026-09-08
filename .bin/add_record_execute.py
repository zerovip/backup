#!/usr/bin/env python
import requests
import datetime
import json
import operator

COUNTRY_CODE_TO_CN = {
    "AD": "安道尔",
    "AE": "阿拉伯联合酋长国",
    "AF": "阿富汗",
    "AG": "安提瓜和巴布达",
    "AI": "安圭拉",
    "AL": "阿尔巴尼亚",
    "AM": "亚美尼亚",
    "AO": "安哥拉",
    "AQ": "南极洲",
    "AR": "阿根廷",
    "AS": "美属萨摩亚",
    "AT": "奥地利",
    "AU": "澳大利亚",
    "AW": "阿鲁巴",
    "AX": "奥兰群岛",
    "AZ": "阿塞拜疆",
    "BA": "波斯尼亚和黑塞哥维那",
    "BB": "巴巴多斯",
    "BD": "孟加拉国",
    "BE": "比利时",
    "BF": "布基纳法索",
    "BG": "保加利亚",
    "BH": "巴林",
    "BI": "布隆迪",
    "BJ": "贝宁",
    "BL": "圣巴泰勒米",
    "BM": "百慕大",
    "BN": "文莱",
    "BO": "玻利维亚",
    "BQ": "荷兰加勒比区",
    "BR": "巴西",
    "BS": "巴哈马",
    "BT": "不丹",
    "BV": "布维岛",
    "BW": "博茨瓦纳",
    "BY": "白俄罗斯",
    "BZ": "伯利兹",
    "CA": "加拿大",
    "CC": "科科斯（基林）群岛",
    "CD": "刚果（金）",
    "CF": "中非共和国",
    "CG": "刚果（布）",
    "CH": "瑞士",
    "CI": "科特迪瓦",
    "CK": "库克群岛",
    "CL": "智利",
    "CM": "喀麦隆",
    "CN": "中国",
    "CO": "哥伦比亚",
    "CR": "哥斯达黎加",
    "CU": "古巴",
    "CV": "佛得角",
    "CW": "库拉索",
    "CX": "圣诞岛",
    "CY": "塞浦路斯",
    "CZ": "捷克",
    "DE": "德国",
    "DJ": "吉布提",
    "DK": "丹麦",
    "DM": "多米尼克",
    "DO": "多米尼加共和国",
    "DZ": "阿尔及利亚",
    "EC": "厄瓜多尔",
    "EE": "爱沙尼亚",
    "EG": "埃及",
    "EH": "西撒哈拉",
    "ER": "厄立特里亚",
    "ES": "西班牙",
    "ET": "埃塞俄比亚",
    "FI": "芬兰",
    "FJ": "斐济",
    "FK": "福克兰群岛（马尔维纳斯）",
    "FM": "密克罗尼西亚联邦",
    "FO": "法罗群岛",
    "FR": "法国",
    "GA": "加蓬",
    "GB": "英国",
    "GD": "格林纳达",
    "GE": "格鲁吉亚",
    "GF": "法属圭亚那",
    "GG": "根西岛",
    "GH": "加纳",
    "GI": "直布罗陀",
    "GL": "格陵兰",
    "GM": "冈比亚",
    "GN": "几内亚",
    "GP": "瓜德罗普",
    "GQ": "赤道几内亚",
    "GR": "希腊",
    "GS": "南乔治亚岛和南桑威奇群岛",
    "GT": "危地马拉",
    "GU": "关岛",
    "GW": "几内亚比绍",
    "GY": "圭亚那",
    "HK": "中国香港",
    "HM": "赫德岛和麦克唐纳岛",
    "HN": "洪都拉斯",
    "HR": "克罗地亚",
    "HT": "海地",
    "HU": "匈牙利",
    "ID": "印度尼西亚",
    "IE": "爱尔兰",
    "IL": "以色列",
    "IM": "马恩岛",
    "IN": "印度",
    "IO": "英属印度洋领地",
    "IQ": "伊拉克",
    "IR": "伊朗",
    "IS": "冰岛",
    "IT": "意大利",
    "JE": "泽西岛",
    "JM": "牙买加",
    "JO": "约旦",
    "JP": "日本",
    "KE": "肯尼亚",
    "KG": "吉尔吉斯斯坦",
    "KH": "柬埔寨",
    "KI": "基里巴斯",
    "KM": "科摩罗",
    "KN": "圣基茨和尼维斯",
    "KP": "朝鲜",
    "KR": "韩国",
    "KW": "科威特",
    "KY": "开曼群岛",
    "KZ": "哈萨克斯坦",
    "LA": "老挝",
    "LB": "黎巴嫩",
    "LC": "圣卢西亚",
    "LI": "列支敦士登",
    "LK": "斯里兰卡",
    "LR": "利比里亚",
    "LS": "莱索托",
    "LT": "立陶宛",
    "LU": "卢森堡",
    "LV": "拉脱维亚",
    "LY": "利比亚",
    "MA": "摩洛哥",
    "MC": "摩纳哥",
    "MD": "摩尔多瓦",
    "ME": "黑山",
    "MF": "圣马丁（法属）",
    "MG": "马达加斯加",
    "MH": "马绍尔群岛",
    "MK": "北马其顿",
    "ML": "马里",
    "MM": "缅甸",
    "MN": "蒙古",
    "MO": "中国澳门",
    "MP": "北马里亚纳群岛",
    "MQ": "马提尼克",
    "MR": "毛里塔尼亚",
    "MS": "蒙特塞拉特",
    "MT": "马耳他",
    "MU": "毛里求斯",
    "MV": "马尔代夫",
    "MW": "马拉维",
    "MX": "墨西哥",
    "MY": "马来西亚",
    "MZ": "莫桑比克",
    "NA": "纳米比亚",
    "NC": "新喀里多尼亚",
    "NE": "尼日尔",
    "NF": "诺福克岛",
    "NG": "尼日利亚",
    "NI": "尼加拉瓜",
    "NL": "荷兰",
    "NO": "挪威",
    "NP": "尼泊尔",
    "NR": "瑙鲁",
    "NU": "纽埃",
    "NZ": "新西兰",
    "OM": "阿曼",
    "PA": "巴拿马",
    "PE": "秘鲁",
    "PF": "法属波利尼西亚",
    "PG": "巴布亚新几内亚",
    "PH": "菲律宾",
    "PK": "巴基斯坦",
    "PL": "波兰",
    "PM": "圣皮埃尔和密克隆",
    "PN": "皮特凯恩群岛",
    "PR": "波多黎各",
    "PS": "巴勒斯坦",
    "PT": "葡萄牙",
    "PW": "帕劳",
    "PY": "巴拉圭",
    "QA": "卡塔尔",
    "RE": "留尼汪",
    "RO": "罗马尼亚",
    "RS": "塞尔维亚",
    "RU": "俄罗斯",
    "RW": "卢旺达",
    "SA": "沙特阿拉伯",
    "SB": "所罗门群岛",
    "SC": "塞舌尔",
    "SD": "苏丹",
    "SE": "瑞典",
    "SG": "新加坡",
    "SH": "圣赫勒拿",
    "SI": "斯洛文尼亚",
    "SJ": "斯瓦尔巴岛和扬马延岛",
    "SK": "斯洛伐克",
    "SL": "塞拉利昂",
    "SM": "圣马力诺",
    "SN": "塞内加尔",
    "SO": "索马里",
    "SR": "苏里南",
    "SS": "南苏丹",
    "ST": "圣多美和普林西比",
    "SV": "萨尔瓦多",
    "SX": "圣马丁（荷属）",
    "SY": "叙利亚",
    "SZ": "斯威士兰",
    "TC": "特克斯和凯科斯群岛",
    "TD": "乍得",
    "TF": "法属南部领地",
    "TG": "多哥",
    "TH": "泰国",
    "TJ": "塔吉克斯坦",
    "TK": "托克劳",
    "TL": "东帝汶",
    "TM": "土库曼斯坦",
    "TN": "突尼斯",
    "TO": "汤加",
    "TR": "土耳其",
    "TT": "特立尼达和多巴哥",
    "TV": "图瓦卢",
    "TW": "中国台湾",
    "TZ": "坦桑尼亚",
    "UA": "乌克兰",
    "UG": "乌干达",
    "UM": "美国本土外小岛屿",
    "US": "美国",
    "UY": "乌拉圭",
    "UZ": "乌兹别克斯坦",
    "VA": "梵蒂冈",
    "VC": "圣文森特和格林纳丁斯",
    "VE": "委内瑞拉",
    "VG": "英属维尔京群岛",
    "VI": "美属维尔京群岛",
    "VN": "越南",
    "VU": "瓦努阿图",
    "WF": "瓦利斯和富图纳",
    "WS": "萨摩亚",
    "YE": "也门",
    "YT": "马约特",
    "ZA": "南非",
    "ZM": "赞比亚",
    "ZW": "津巴布韦",
}

def code_to_chinese(code):
    return COUNTRY_CODE_TO_CN.get(code.upper(), code)

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
        date_list = mark_date.replace("/","-").split("-")
        mark_date = str(datetime.date(int(date_list[0]), int(date_list[1]), int(date_list[2])))
    my_score_n = input("请输入评分，1-5 之间的整数：")
    my_score = "★" * int(my_score_n)
    my_comment = input("请输入点评：")
    book_dict = {
            "title": title,
            "author": author,
            "public_year": public_year,
            "press": press,
            "link": link,
            "isbn": isbn,
            "mark_date": mark_date,
            "my_score": my_score,
            "my_comment": my_comment
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
    headers = {"Authorization": "Bearer " + token}
    data = {}

    item_url = "https://neodb.social/api/book/" + uuid
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

    mark_url = "https://neodb.social/api/me/shelf/item/" + uuid
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
        date_list = mark_date.replace("/","-").split("-")
        mark_date = str(datetime.date(int(date_list[0]), int(date_list[1]), int(date_list[2])))
    my_score_n = input("请输入评分，1-5 之间的整数：")
    my_score = "★" * int(my_score_n)
    my_comment = input("请输入点评：")
    film_dict = {
            "title": title,
            "ori_name": ori_name,
            "public_year": public_year,
            "produce_country": produce_country,
            "film_type": film_type,
            "director": director,
            "link": link,
            "imdb_id": imdb_id,
            "mark_date": mark_date,
            "my_score": my_score,
            "my_comment": my_comment
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


def get_director_info(token, url):
    name_url = "https://neodb.social" + url
    headers = {"Authorization": "Bearer " + token}
    name_req = requests.get(name_url, headers = headers)
    name_j = name_req.json()
    return name_j

def get_chinese_name(director_info):
    if not director_info or "localized_name" not in director_info:
        return None
    for name_info in director_info["localized_name"]:
        if name_info.get("lang") == "zh-cn":
            return name_info.get("text")
    return None

def get_localized_director_name(token, item_j):
    if "director" not in item_j or not item_j["director"]:
        return "null"
    person_url_map = {}
    for credit in item_j.get("credits", []):
        if credit.get("role") == "director" and credit.get("person_url"):
            person_url_map[credit.get("name")] = credit.get("person_url")
    chinese_names = []
    for director_name in item_j["director"]:
        person_url = person_url_map.get(director_name)
        if person_url:
            director_info = get_director_info(token, person_url)
            chinese_name = get_chinese_name(director_info)
            if chinese_name:
                chinese_names.append(chinese_name)
            else:
                chinese_names.append(director_name)
        else:
            chinese_names.append(director_name)
    return " ".join(chinese_names) if chinese_names else "null"

def translate_genre_list(genre_list, genre_file="/home/orez/.bin/genre.json"):
    with open(genre_file, "r", encoding="utf-8") as f:
        genre_map = json.load(f)
    translated = []
    for genre in genre_list:
        genre_lower = genre.lower().strip()
        if genre_lower in genre_map:
            translated.append(genre_map[genre_lower])
        else:
            print(f"\n未找到类型 '{genre}' 的翻译")
            user_input = input(f"请输入 '{genre}' 的中文翻译（直接回车跳过）：").strip()
            if user_input:
                genre_map[genre_lower] = user_input
                with open(genre_file, "w", encoding="utf-8") as f:
                    json.dump(genre_map, f, ensure_ascii=False, indent=2)
                translated.append(user_input)
                print(f"已保存映射: {genre} -> {user_input}")
            else:
                translated.append(genre)
                print(f"已跳过 '{genre}'")
    return translated

def search_film_neodb(uuid, token):
    headers = {"Authorization": "Bearer " + token}
    data = {}

    item_url = "https://neodb.social/api/movie/" + uuid
    item_req = requests.get(item_url, headers = headers)
    item_j = item_req.json()
    # print(json.dumps(item_j, ensure_ascii=False))
    data["title"] = item_j.get("title", "null")
    local_title_list = item_j.get("localized_title", [])
    for local_title_pair in local_title_list:
        if local_title_pair.get("lang", "null") == "zh-cn":
            data["title"] = local_title_pair.get("text", "null")
            break
    data["ori_name"] = item_j.get("orig_title", "null")
    data["public_year"] = str(item_j.get("year", "null"))
    data["produce_country"] = " ".join([code_to_chinese(c) for c in item_j.get("area", ["null"])])
    data["film_type"] = " ".join(translate_genre_list(item_j.get("genre", ["null"])))
    data["director"] = get_localized_director_name(token, item_j)
    data["link"] = "null"
    ext_links = item_j.get("external_resources", [])
    for i in range(len(ext_links)):
        link = ext_links[i]["url"]
        if "douban" in link:
            data["link"] = link
    data["imdb_id"] = item_j.get("imdb", "null")

    mark_url = "https://neodb.social/api/me/shelf/item/" + uuid
    mark_req = requests.get(mark_url, headers = headers)
    mark_j = mark_req.json()
    #print(mark_j)
    data["mark_date"] = mark_j.get("created_time", "null")
    data["my_score"] = "★" * (mark_j.get("rating_grade", 2) // 2)
    data["my_comment"] = replace_bbk(mark_j.get("comment_text", "null"))
    #print(data)

    return data

def search_tv_neodb(uuid, token):
    headers = {"Authorization": "Bearer " + token}
    data = {}

    item_url = "https://neodb.social/api/tv/season/" + uuid
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
        tv_url = "https://neodb.social/api/tv/" + parent_uuid
        tv_req = requests.get(tv_url, headers = headers)
        tv_j = tv_req.json()
        data["imdb_id"] = tv_j.get("imdb", "null")

    mark_url = "https://neodb.social/api/me/shelf/item/" + uuid
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
    with open(add, "r") as old_file:
        old_data = json.load(old_file)
    old_data.append(data_dict)
    old_data.sort(key = operator.itemgetter("mark_date"), reverse = True)
    with open (add, "w") as new_file:
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
