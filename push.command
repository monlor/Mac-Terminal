#!/bin/bash
# ./push.command这类形式，用第二种方法获取，想怎么运行都行
if [ -z "`echo $0 | grep "^\.\/[^/]*$"`" ]; then
	ProjectPath="$(echo $0 | sed -e "s|/[^/]*$||")"
	ProjectName="$(echo $ProjectPath | sed -e "s|[/]*.*/||")"
else
	ProjectPath="$(pwd)"
	ProjectName="$(echo $ProjectPath | sed -e "s|/.*/||")"
fi

[ -z "$ProjectName" ] && echo "Null Project Name!" && exit
GitUrl="https://github.com/monlor"
echo "Push [$ProjectName] To [$GitUrl/$ProjectName.git]."
cd "$ProjectPath"
find . -name '.DS_Store' | xargs rm -rf
git add .
git commit -m "`date +%Y-%m-%d`"
git remote rm origin
git remote add origin "$GitUrl"/"$ProjectName".git
git push -u origin master -f
