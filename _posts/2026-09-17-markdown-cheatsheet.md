---
layout: post
title: "Markdown 语法速查"
date: 2026-09-17 20:00:00 +0800
categories: [技术]
tags: [Markdown, 速查]
---

写博客最常用的 Markdown 语法整理，方便随时查阅。

<!--more-->

## 标题

```markdown
# 一级标题
## 二级标题
### 三级标题
```

## 强调

*斜体*、**粗体**、~~删除线~~、`行内代码`

## 列表

- 无序列表项
- 另一项
  - 嵌套项

1. 有序列表
2. 第二项

## 链接与图片

```markdown
[链接文字](https://example.com)
![图片描述](/assets/images/example.png)
```

## 引用

> 这是一段引用。
> 可以有多行。

## 代码块

```python
def hello(name: str) -> str:
    return f"Hello, {name}!"

print(hello("Jekyll"))
```

## 表格

| 左对齐 | 居中 | 右对齐 |
|:-------|:----:|-------:|
| a      |  b   |      c |

## 任务列表

- [x] 已完成
- [ ] 未完成

## 分隔线

---

以上就是最常用的语法了。
