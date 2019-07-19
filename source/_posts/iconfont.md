---
title: iconfont 库实现
tags:
  - iconfont
date:
categories:
  - iconfont
---
# iconfont 库实现

## 0. 背景
新技术栈引入了 Ant Design，其 内置的字体并不满足业务开发需求，需要实现一套相对通用的逻辑封装，实现由设计师上传设计资源生成相应的图标预览。

<!-- more -->
## 1. 设计目标

1. 一套系统中只存在一种字体文件
2. iconfont 库以 gitlab 私有 npm 包引入项目，辅助一些构建脚本
3. 使用时与 antd 默认 Icon 机制无差别，即 <Icon type={*} />

## 2. 实现过程

### 2.1 初期构想

    1. 最开始构想为自定义字体与 antd 默认字体同时存在，两套系统type名称以前缀进行区别 (违背了设计 1.1 需求)
    2. 字体文件覆盖，antd官方支持可配置字体路径，本地通过脚本生成相应的字体文件，导入对应的路径。


> 最终选择使用 [icon-font-generator](https://www.npmjs.com/package/icon-font-generator) 库，通过脚本配置直接生成对应的概览

### 2.2 中期实现困难

#### 2.2.1 基本库的选择

尽可能选择更新较为频繁或者比较成熟的库来实现，最终选择 [icon-font-generator](https://github.com/Workshape/icon-font-generator#readme) 。

```
icon-font-generator assets/svg/*.svg -n iconfont --height=1000 -p anticon -o icon-dist --center
```
`注:` `--height=1000` 是为了提高图形质量。

#### 2.2.2 资源打包

由于在项目中使用了 css-module，生成的字体 css 文件不能直接 import 进项目中应用，所以只能放在 public 文件夹下面，这样打包时不会处理对应的文件资源。

#### 2.2.3 antd icon 显示的坑

在 antd 框架内，有两种展示icon的方式

 - 带有 anticon 以及 anticon-* 的标签
 - 内置部分类名，定义该类伪类 content 为对应icon的编码

对于第二种情况，需要手动定义该内置类名与新字体库中应显示图标的映射。

> 解决方案：基于 `2.2.1` 中生成的 json 文件，将字体名的编码映射到对应的伪类中。辅助库：[jdists](https://github.com/zswang/jdists)

#### 2.2.4 字体资源文件维护

多个项目使用时，避免文件传来传去，以及实现由设计同学来输入原始的svg资源，最终自动生成字体图标的预览。

> 解决方案：将字体库抽离具体项目，代之以私有npm包的形式作为项目依赖。

#### 2.2.5 antd 版本升级，图标机制修改

antd 在 `3.9.0` 版本开始，将`fontface`替换为`svg`，导致升级后图标位置出现两个方框。

> 解决方案：将现有的antd版本锁定在3.8.x。

#### 2.2.6 svg资源规范

在完成以上步骤，引入项目中后，会发现字体很难与文字对齐

> 解决方案：将svg资源设置为 `32x32` 的尺寸，以及默认将字体内容填充至填满整个区域。


### 3. 总结与探索

常见的字体机制
 1. unicode
    1. 兼容性最好，支持ie6+，及所有现代浏览器。
    2. 支持按字体的方式去动态调整图标大小，颜色等等。
    3. 不支持多色
 2. font-class
    1. 兼容性良好，支持ie8+，及所有现代浏览器。
    2. 书写更直观
    3. 也不支持多色
 3. symbol
    1. `支持多色！！！！`
    2. 支持 ie9+,及现代浏览器。（符合要求）

接下来可以改进的地方

1. 现有的gitlab机制，新增svg时仍然需要手动去本地build一下字体文件再push到对应的分支，可以考虑在 ci 机器上build完成直接推送到分支
2. 与现有技术栈更匹配的字体库实现方式
    [演示地址](https://www.smooth-code.com/open-source/svgr/playground/)
