#!/usr/bin/env python

import sys
import json
import requests

if len(sys.argv) == 3:
    ori_file = sys.argv[1]
    token = 'Bearer ' + sys.argv[2]

headers = {'Authorization': token}

file_name_list = ori_file.split('.')
new_file = file_name_list[0] + '_new.' + file_name_list[1]

of = open(ori_file, 'r')
nf = open(new_file, 'w')

toot1 = '''{{{{< toot
    created_at="{created_at}"
    sensitive={sensitive}
    spoiler_text="{spoiler_text}"
    url="{url}"
    replies_count={replies_count}
    reblogs_count={reblogs_count}
    favourites_count={favourites_count}
    media_attachments={media_attachments}
'''
toot2 = '''>}}}}
    {content}
{{{{< /toot >}}}}
'''

for line in of:
    if (len(line) > 15) and (line[0:12] == '<iframe src='):
        sid = line.split(' ')[1].split('/')[4]
        api = 'https://1234.as/api/v1/statuses/' + sid
        ss = requests.get(api, headers = headers)
        ssj = ss.json()
        mlenth = len(ssj['media_attachments'])
        new_lines = toot1.format(
                created_at = ssj['created_at'],
                sensitive = str(ssj['sensitive']).lower(),
                spoiler_text = ssj['spoiler_text'],
                url = ssj['url'],
                replies_count = ssj['replies_count'],
                reblogs_count = ssj['reblogs_count'],
                favourites_count = ssj['favourites_count'],
                media_attachments = mlenth
                )
        if mlenth >= 1:
            new_lines += '    m0u="{url}"\n    m0d="{cap}"\n'.format(
                    url = ssj['media_attachments'][0]['url'],
                    cap = ssj['media_attachments'][0]['description']
                    )
        if mlenth >= 2:
            new_lines += '    m1u="{url}"\n    m1d="{cap}"\n'.format(
                    url = ssj['media_attachments'][1]['url'],
                    cap = ssj['media_attachments'][1]['description']
                    )
        if mlenth >= 3:
            new_lines += '    m2u="{url}"\n    m2d="{cap}"\n'.format(
                    url = ssj['media_attachments'][2]['url'],
                    cap = ssj['media_attachments'][2]['description']
                    )
        if mlenth == 4:
            new_lines += '    m3u="{url}"\n    m3d="{cap}"\n'.format(
                    url = ssj['media_attachments'][3]['url'],
                    cap = ssj['media_attachments'][3]['description']
                    )
        new_lines += toot2.format(content = ssj['content'])
        nf.write(new_lines)
        print(ssj['id'] + '    done.')
    else:
        nf.write(line)

of.close()
nf.close()

