## SimpleUML


最简单的生成UML图程序.
简单到只用几条命令即可生成.

### 起因

最近在研究live555 rtsp推流程序.里面的类结构过于复杂,考虑将类结构画出来,方便了解.
能从代码直接生成UML图的程序,我知道的就只有 `Umbrello` .

但是在使用的过程中,导入时一直崩溃.

开动小脑筋思考了一下:
是不是里面的类结构过于复杂, 导致走出Umbrello的处理能力?
是不是C++ 新增的语法, 而Umbrello因为要处理类里面的成员函数,导致出错?

百思不得其解,因些给 KDE 报了一个BUG.

https://bugs.kde.org/show_bug.cgi?id=456427


### 自创野路子

问题提交后,工作还是要继续.

有鉴于我只是想要知道类的关系,完全可以把类内成员函数的处理忽略掉.

观察了一下live555的代码,编写的风格还算统一,每个类的定义大括号都与类名称在同一行.形如

```
class subclass : public baseclass {

};

```

那我可以写一个脚本,把这些类的相关信息提出来.转为mermaid语法的结构.
通过mermaid提供的网站把图画出来.

[https://mermaid-js.github.io/mermaid-live-editor/edit](https://mermaid-js.github.io/mermaid-live-editor/edit)


### 注意的事项

在填写到mermaid代码里时,因为类实在太多,如果按默认的方式来画的话,mermaid会出错.
因此,需要把类图作一个横向作图.

在前面加上二个

```
classDiagram
direction RL

```

### 缺点

图是画出来了,只是太大,无法正常显示. 

不过这个方法可以推广到其他源码库里.只要不是过于复杂的库,应该可以画出来.


### 使用plantuml

如果使用plantuml来画图,只需要在最终的文件前后各加上二句

```
@startuml
scale 4096 width 

//文件内容

@enduml

```

同样,画出来的图片太大,一张图片里根本无法容纳这么多元素.

可以想像, 后续Umbrello修复了崩溃的问题后,画图仍是一个令人头痛的问题.


### 需要改进的地方

#### 类定义的多种方式

在live555这个库里,类名称与大括号在同一行.

```
class subclass : public parent_class {
	...
};

```

但还存在几种常用的定义法:

```
//大括号另起一行
class subclass : public parent_class
{
	...
};

```

```

//父类另起一行
class subclass 
	: public parent_class
{
	...
};

```

这二种还没有处理.

可能在 grep 后面加参数`-A 3`,找出后面的几行.然后把换行符换为空格.把几种格式换为live555类似的格式. 可以处理掉这个问题


#### 多继承关系

如果一个类继承多个父类,需要加额外的处理.
但还不知如果处理.

#### 继承关系的处理

脚本里只处理了public 继承.
如果存在protected继承, private继承关系.需要加上额外的处理.


#### 嵌套类的继承

因为mermaid不能处理 `::` , 所以几乎无解


