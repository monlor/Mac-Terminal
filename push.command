#!/bin/bash
ProjectName="$(echo $0 | sed -e "s|/[^/]*$||" -e "s|/.*/||")"
path=~/SyncFile/Project/$ProjectName
cd $path
[ $? -ne 0 ] && exit
find . -name '.DS_Store' | xargs rm -rf
git add .
git commit -m "`date +%Y-%m-%d`"
git remote rm origin
git remote add origin https://github.com/monlor/$ProjectName.git
git push -u origin master -f
