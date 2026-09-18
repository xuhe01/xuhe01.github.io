# 我的博客

基于 [Jekyll](https://jekyllrb.com/) + [GitHub Pages](https://pages.github.com/) 的个人博客，参考 [GitHub Pages 快速入门](https://docs.github.com/zh/pages/quickstart) 搭建。

## 目录结构

```
.
├── _config.yml          # 站点全局配置（标题、主题、插件、URL 等）
├── Gemfile              # Ruby 依赖，本地预览用
├── index.md             # 首页（自动列出最新文章）
├── about.md             # 「关于我」页面
├── archive.md           # 按年份归档所有文章
├── 404.md               # 自定义 404 页面
├── _posts/              # ✍️ 所有博客文章放这里
│   └── YYYY-MM-DD-slug.md
├── _includes/           # 可复用的 HTML 片段（可选）
└── assets/
    ├── css/style.scss   # 自定义样式（覆盖主题）
    └── images/          # 文章用到的图片
```

## 写一篇新文章

1. 在 `_posts/` 下新建文件，命名为 `YYYY-MM-DD-英文短标题.md`
2. 文件开头写 Front Matter：

   ```yaml
   ---
   layout: post
   title: "文章标题"
   date: 2026-09-18 10:00:00 +0800
   categories: [技术]
   tags: [标签1, 标签2]
   ---
   ```

3. 下面写 Markdown 正文；在想要「阅读全文」截断的地方插入 `<!--more-->`
4. `git add . && git commit -m "post: 文章标题" && git push`
5. 等 1~2 分钟，GitHub Actions 会自动构建并发布

## 本地预览

需要 Ruby ≥ 2.7 与 Bundler：

```bash
bundle install
bundle exec jekyll serve --livereload
# 打开 http://localhost:4000
```

## 部署到 GitHub Pages

详见项目根目录下的 `DEPLOY.md`。

## 常用命令

| 命令 | 说明 |
|------|------|
| `bundle exec jekyll serve` | 本地启动开发服务器 |
| `bundle exec jekyll build` | 构建静态文件到 `_site/` |
| `bundle exec jekyll serve --drafts` | 同时预览 `_drafts/` 中的草稿 |
| `bundle update github-pages` | 更新到 GitHub Pages 最新依赖 |

## License

文章内容采用 [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.zh) 许可，代码采用 MIT 许可。
