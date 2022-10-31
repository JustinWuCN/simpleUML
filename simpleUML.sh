#!/bin/bash

# 需要先进入live555/liveMedia目录下
find.word "\<class.*{" > live555

cat live555 | sed -e 's/.*class \(.*\){/\1/' > classonly2

cat classonly2 | sed -e 's/\(.*\): public \(.*\)/\2 <|-- \1/' > classDiagram

cat classDiagram | grep "<|--" >> classDiagram2

#这里有必个子类的继承,里面有"::"字符.在mermaid里处理会出错.先把这几个过滤掉
cat classDiagram2 | grep -Ev "::" >> classDiagram3

## 把上面得到的最终文件,放到mermaid里去.
## 前面加上二句
## classDiagram
## direction RL

