---
title: Hadoop 基础
tags:
  - Hadoop
date: 
categories:
  - 技术
---
Hadoop的核心就是HDFS和MapReduce，而两者只是理论基础，不是具体可使用的高级应用，Hadoop旗下有很多经典子项目，比如HBase、Hive等，这些都是基于HDFS和MapReduce发展出来的。要想了解Hadoop，就必须知道HDFS和MapReduce是什么。
<!-- more -->
### 1. 核心部分

  * 分布式文件系统HDFS
  * Mapreduce
  * 数据仓库工具Hive
  * 分布式数据库 Hbase


### 2. 一个Hadoop集群由一个NameNode和若干个DataNode组成。

  * NameNode 作为主服务器，用来管理文件系统命名空间和客户端对文件的访问操作。
  * DataNode 管理存储的数据，支持文件格式的数据。


### 3. 文件读取 / 写入过程
#### 3.1 文件读取
  1. Client向NameNode发起文件写入的请求。
  2. NameNode根据文件大小和文件块配置情况，返回给Client它管理的DataNode的信息。
  3. Client将文件划分为多个block，根据DataNode的地址，按顺序将block写入DataNode块中。

#### 3.2 文件写入
  1. Client向NameNode发起读取文件的请求。
  2. NameNode返回文件存储的DataNode信息。
  3. Client 读取文件信息。

> 文件块的放置，一个block一般会有三个备份，一份在NameNode指定的DateNode上，一份放在与指定的DataNode不在同一台机器的DataNode上，一根在于指定的DataNode在同一Rack上的DataNode上。


### 4. MapReduce 体系结构


 MR框架是由一个单独运行在主节点上的JobTracker和运行在每个集群从节点上的TaskTracker共同组成。主节点负责调度构成一个作业的所有任务，这些任务分布在不同的不同的从节点上。主节点监视它们的执行情况，并重新执行之前失败的任务。从节点仅负责由主节点指派的任务。当一个Job被提交时，JobTracker接受到提交作业和配置信息之后，就会将配置信息等分发给从节点，同时调度任务并监控TaskTracker的执行。

 DataNode既是数据存储节点又是计算节点。

 MR编程模型原理
 利用一个输入的key-value对集合来产生一个输出的key-value对集合。MR库通过Map和Reduce两个函数来实现这个框架。用户自定义的map函数接受一个输入的key-value对，然后产生一个中间的key-value对的集合。MR把所有具有相同的key值的value结合在一起，然后 传递个reduce函数。Reduce函数接受key和相关的value结合，reduce函数合并这些value值，形成一个较小的value集合。通常我们通过一个迭代器把中间的value值提供给reduce函数（迭代器的作用就是收集这些value值），这样就可以处理无法全部放在内存中的大量的value值集合了。


### 5. Hive
 #### 5.1 Hive 概念
 Hive是建立在Hadoop上的数据仓库基础架构。它提供了一系列的工具，用来进行数据提取、转换、加载，这是一种可以存储、查询和 分析存储在Hadoop中的大规模数据机制。可以把Hadoop下结构化数据文件映射为一张成Hive中的表，并提供类sql查询功能，除了不支持更新、索引和事务，sql其它功能都支持。可以将sql语句转换为MapReduce任务进行运行，作为sql到MapReduce的映射器。提供shell、JDBC/ODBC、Thrift、Web等接口。优点：成本低可以通过类sql语句快速实现简单的MapReduce统计。

#### 5.2 数据仓库
##### 5.2.1 元数据存储
三种连接数据的方式:
* 内嵌模式：元数据保持在内嵌数据库的Derby，一般用于单元测试，只允许一个会话连接
* 多用户模式：在本地安装Mysql，把元数据放到Mysql内
* 远程模式：元数据放置在远程的Mysql数据库


#### 5.2.2 数据存储
Hive没有专门的数据存储格式，也没有为数据建立索引，用于可以非常自由的组织Hive中的表，只需要在创建表的时候告诉Hive数据中的列分隔符和行分隔符，这就可以解析数据了。

 Hive中的四种数据模型：Table、ExternalTable、Partition、Bucket。

 * Table。类似与传统数据库中的Table，每一个Table在Hive中都有一个相应的目录来存储数据。
 * Partition。类似于传统数据库中划分列的索引。
 * Buckets。对指定列计算的hash，根据hash值切分数据，目的是为了便于并行，每一个Buckets对应一个文件。
 * ExternalTable。指向已存在HDFS中的数据，可创建Partition。

 Hive中的元数据包括表的名字、表的列和分区及其属性、表的属性（是否为外部表）、表数据所在的目录等。
