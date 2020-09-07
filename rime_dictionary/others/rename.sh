#!/bin/bash
for file in *.dict.yaml
do
    sed -i "1s/^/---\nname: ${file:0:0-10}\nversion: \"2020.09.07\"\nsort: by_weight\nuse_preset_vocabulary: true\n...\n/" $file
    echo $file
done
