#!/bin/bash
for i in `find -name \*.txt`
do
    vim -s to_utf8.vi $i
done
