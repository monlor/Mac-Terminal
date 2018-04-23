#!/bin/bash

git add .
git commit -m "`date +%Y-%m-%d`"
git remote rm origin
git remote add origin https://github.com/monlor/Mac-Terminal.git
git push -u origin master -f
