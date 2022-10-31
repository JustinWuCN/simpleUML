#!/bin/bash

# 需要先进入live555/liveMedia目录下

#1. 找出所有的类定义.
# find.word是自己写的一个脚本,里面只有一句
# find . -type f -iname  "*${2}*" -print0 |xargs -0 file|grep 'ASCII\|UTF\|ISO-8859' | awk '{print $1}'|tr -d ':' | xargs grep --color=auto "$1" -nri
#TODO, 这里只处理了大括号与类定义在同一行的情况,如果要处理其他情况,需要另外处理.
#有的类定义大括号与类定义分为二行
#  class subclass : public xxxx
# {
#有的定义父类与类定义分为二行
# class subclass
#	: public xxxx {


find.word "\<class.*{" > live555

# 2. 取出类名
cat live555 | sed -e 's/.*class \(.*\){/\1/' > classonly2

#3. 把类关系的描述替换为 <|-- 方式.
#TODO: 这里只考虑到了public继承的方式.
cat classonly2 | sed -e 's/\(.*\): public \(.*\)/\2 <|-- \1/' > classDiagram


#4. 去掉没有继承关系的类
cat classDiagram | grep "<|--" >> classDiagram2

#5. 把类内包含的类继承去掉.这一步是因为mermaid不能处理类内继承,如果使用plantuml,可以不必处理.
#这里有必个子类的继承,里面有"::"字符.在mermaid里处理会出错.先把这几个过滤掉
cat classDiagram2 | grep -Ev "::" >> classDiagram3

## 把上面得到的最终文件classDiagram3的内容,放到mermaid里去.
## 前面加上二句
## classDiagram
## direction RL

