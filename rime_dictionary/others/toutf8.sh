#!/bin/bash
for i in `find -name \*.txt`
do
    vim -s toutf8.vi $i
done
