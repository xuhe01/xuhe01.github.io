---
layout: post
title: "如何用 GitHub Pages 搭建博客"
date: 2026-09-18 11:00:00 +0800
categories: [技术]
tags: [GitHub Pages, Jekyll, 教程]
---

本文记录我用 GitHub Pages 搭建这个博客的完整步骤，参考了官方的[快速入门文档](https://docs.github.com/zh/pages/quickstart)。

<!--more-->

## 1. 创建仓库

在 GitHub 上新建一个仓库，命名为 `xuhe01.github.io`（`xuhe01` 是你的 GitHub 用户名），设为 **Public**。

## 2. 准备 Jekyll 站点

最少只需要三个文件：

```text
.
├── _config.yml      # 站点配置
├── index.md         # 首页
└── _posts/          # 文章目录
    └── 2026-09-18-hello-world.md
```

`_config.yml` 里指定主题：

```yaml
title: 我的博客
theme: minima
plugins:
  - jekyll-feed
```

## 3. 写文章

文章放在 `_posts/` 目录，文件名格式为 `YYYY-MM-DD-标题.md`，顶部要有 Front Matter：

```markdown
---
layout: post
title: "文章标题"
date: 2026-09-18 10:00:00 +0800
tags: [标签1, 标签2]
---

正文内容……
```

## 4. 推送并启用 Pages

```bash
git add .
git commit -m "Initial blog"
git remote add origin https://github.com/xuhe01/xuhe01.github.io.git
git push -u origin main
```

然后到仓库 **Settings → Pages**，Source 选择 `Deploy from a branch`，Branch 选 `main` / `(root)`，保存。

等一两分钟，访问 `https://xuhe01.github.io` 就能看到博客了。

## 5. 本地预览（可选）

```bash
bundle install
bundle exec jekyll serve
```

浏览器打开 <http://localhost:4000>。

## 常见问题

| 问题 | 解决方案 |
|------|----------|
| 页面 404 | 检查仓库名是否正确、Pages 是否已启用、等待构建完成 |
| 样式丢失 | 项目站点需要设置 `baseurl: "/仓库名"` |
| 文章不显示 | 检查文件名日期格式；未来日期的文章默认不发布 |

就是这么简单！
