#!/bin/bash
ProjectName="$(echo $0 | sed -e "s|/[^/]*$||" -e "s|/.*/||")"
GitUrl="https://github.com/monlor"
echo "Push [$ProjectName] To [$GitUrl/$ProjectName.git]."
path=~/SyncFile/Project/"$ProjectName"
cd $path
[ $? -ne 0 ] && exit
find . -name '.DS_Store' | xargs rm -rf
git add .
git commit -m "`date +%Y-%m-%d`"
git remote rm origin
git remote add origin "$GitUrl"/"$ProjectName".git
git push -u origin master -f
