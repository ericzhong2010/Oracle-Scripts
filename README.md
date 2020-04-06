# Oracle Scripts



[TOC]

### 00 概述信息

在此记录我在Oracle数据库部署、维护、调优相关的脚本。有许多是网上收集脚本而不是自己原创，如有侵犯版权请邮件通知(ericzhong2010@qq.com)。



### 01 Statistics 统计信息

- sosihtml.sql

  脚本执行：

  ```
  @sosihtml.sql [owner] [table]
  ```

  脚本说明：

  只需要提供用户名以及表名即可罗列出某用户下某表的当前的统计信息内容。如果该表存在索引，则索引的统计信息也同时会被罗列。

- 

