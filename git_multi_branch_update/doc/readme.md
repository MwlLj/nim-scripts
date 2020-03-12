[TOC]

## 执行方式
- ./git_multi_branch_update -src 待提交的文件/目录 -dst git中的目标位置 -filter 要提交的分支 -exclude 排除的分支 -log 提交日志 -files 文件

## 参数说明
- src: 需要提价的文件/目录, 子目录会递归提交
- dst: 提交到git上的目录
- filter: 指定要提交的分支, 使用逗号分隔, 如:
    - alpha,v1.7
- exclude: 指定排除的分支, 使用逗号分隔, 如:
    - v1.6,master
- log: 指定提交的日志
- files: 使用 分号 分隔
    - 新增的情况, 表示的是需要添加的子目录/文件
    - 删除的情况, 表示的是需要删除的子目录/文件

## git地址
- https://github.com/MwlLj/nim-scripts
