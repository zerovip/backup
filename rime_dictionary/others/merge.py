def ReadTxtName(rootdir):
    lines = []
    with open(rootdir, 'r') as file_to_read:
        while True:
            line = file_to_read.readline()
            if not line:
                break
            line = line.strip('\n')
            lines.append(line)
    return lines

def print_member(list):
    index = 0
    while index < len(list):
        print(list[index])
        index += 1

# first = ReadTxtName('./sougou_plant.txt')
# second = ReadTxtName('./baidu_plant.txt')

# result = list(set(first) - set(second))
# print_member(result)

# python3 ./merge.py > ./result/plant_sg-bd.txt

c1 = ReadTxtName('./转换成果/sougou_c1.txt')
c2 = ReadTxtName('./转换成果/sougou_c2.txt')
c3 = ReadTxtName('./转换成果/sougou_c3.txt')

# print("c1-c2\n")
# print_member(list(set(c1)-set(c2)))
# print("c1-c3\n")
# print_member(list(set(c1)-set(c3)))
# print("c2-c1\n")
# print_member(list(set(c2)-set(c1)))
# print("c2-c3\n")
# print_member(list(set(c2)-set(c3)))
# print("c3-c1\n")
# print_member(list(set(c3)-set(c1)))
# print("c3-c2\n")
# print_member(list(set(c3)-set(c2)))

print_member(list( set(c1) | set(c2) | set(c3) ))

