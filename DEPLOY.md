# 部署指南

按照 [GitHub Pages 快速入门](https://docs.github.com/zh/pages/quickstart) 的步骤，把这个博客发布到 `https://xuhe01.github.io`。

> 下文所有 `xuhe01` 请替换为你自己的 GitHub 用户名（注意全部小写）。

---

## 第 0 步：替换占位符

在推送前，先把项目里的占位符替换成你自己的信息：

```bash
# macOS / Linux，一条命令全局替换
grep -rl "xuhe01" --exclude-dir=.git --exclude-dir=_site . | xargs sed -i '' 's/xuhe01/你的github用户名/g'
```

另外手动编辑 `_config.yml` 中的 `title`、`description`、`author`、`email`，以及 `about.md` 中的自我介绍。

---

## 第 1 步：在 GitHub 上创建仓库

1. 登录 GitHub，点击右上角 **+** → **New repository**
2. **Repository name** 填 `xuhe01.github.io`
   - ⚠️ 必须与你的用户名完全一致（大小写不敏感，但建议小写），否则不会成为「用户站点」
3. 选择 **Public**（免费账号的 Pages 只支持公开仓库）
4. **不要**勾选 "Add a README"（本地已经有了）
5. 点击 **Create repository**

---

## 第 2 步：推送代码

在本项目目录下执行：

```bash
# 如果还没设置过 Git 身份
git config user.name  "你的名字"
git config user.email "你的邮箱"

git add .
git commit -m "🎉 Initial blog with Jekyll"
git branch -M main
git remote add origin https://github.com/xuhe01/xuhe01.github.io.git
git push -u origin main
```

> 首次推送会要求登录。GitHub 已不支持密码推送，请使用
> [Personal Access Token](https://github.com/settings/tokens) 或配置 SSH key。

---

## 第 3 步：启用 GitHub Pages

1. 打开仓库页面 → **Settings** → 左侧 **Pages**
2. **Build and deployment** → **Source** 选择 **Deploy from a branch**
3. **Branch** 选择 `main`，目录选 `/ (root)`，点击 **Save**
4. 等待 1~3 分钟，页面顶部会出现 ✅ *Your site is live at https://xuhe01.github.io*

可以在仓库的 **Actions** 标签页看到名为 `pages build and deployment` 的工作流，绿色 ✔ 表示部署成功。

---

## 第 4 步：验证

浏览器打开 `https://xuhe01.github.io`，应该能看到：

- 首页列出 3 篇示例文章
- 顶部导航有「关于我」「归档」
- 点击文章能进入详情页
- `https://xuhe01.github.io/feed.xml` 输出 RSS

---

## 日常更新流程

```bash
# 1. 写文章
vim _posts/2026-09-20-my-new-post.md

# 2. 本地预览（可选）
bundle exec jekyll serve

# 3. 推送
git add .
git commit -m "post: 新文章标题"
git push
```

推送后 GitHub 自动重新构建，约 1 分钟生效。可能需要强制刷新（`Cmd/Ctrl + Shift + R`）清除浏览器缓存。

---

## 进阶选项

### A. 使用 GitHub Actions 部署（可用任意 Jekyll 版本/插件）

默认的「Deploy from a branch」只能用 GitHub Pages [白名单内的插件](https://pages.github.com/versions/)。如需自定义插件，改用 Actions：

1. **Settings → Pages → Source** 改为 **GitHub Actions**
2. 新建 `.github/workflows/jekyll.yml`：

```yaml
name: Deploy Jekyll site to Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.2'
          bundler-cache: true
      - uses: actions/configure-pages@v5
        id: pages
      - run: bundle exec jekyll build --baseurl "${{ steps.pages.outputs.base_path }}"
        env:
          JEKYLL_ENV: production
      - uses: actions/upload-pages-artifact@v3

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - uses: actions/deploy-pages@v4
        id: deployment
```

3. 把 `Gemfile` 中的 `gem "github-pages"` 换成 `gem "jekyll", "~> 4.3"` 即可使用最新 Jekyll。

### B. 绑定自定义域名

1. 在域名 DNS 添加记录：
   - 顶级域名 `example.com`：4 条 **A** 记录指向
     `185.199.108.153` / `185.199.109.153` / `185.199.110.153` / `185.199.111.153`
   - 子域名 `blog.example.com`：1 条 **CNAME** 记录指向 `xuhe01.github.io`
2. **Settings → Pages → Custom domain** 填入域名，保存
3. 勾选 **Enforce HTTPS**（证书签发需要几分钟到一小时）
4. 把 `_config.yml` 的 `url` 改为 `https://你的域名`

### C. 项目站点（仓库名不是 xuhe01.github.io）

如果仓库叫 `my-blog`，站点地址会是 `https://xuhe01.github.io/my-blog/`，此时必须在 `_config.yml` 里设置：

```yaml
baseurl: "/my-blog"
```

否则 CSS 和链接会全部 404。

### D. 更换主题

GitHub Pages 官方支持的主题（改 `_config.yml` 的 `theme:` 即可）：

`minima` · `jekyll-theme-cayman` · `jekyll-theme-minimal` · `jekyll-theme-hacker` · `jekyll-theme-slate` · `jekyll-theme-architect` · `jekyll-theme-dinky` · `jekyll-theme-leap-day` · `jekyll-theme-merlot` · `jekyll-theme-midnight` · `jekyll-theme-modernist` · `jekyll-theme-tactile` · `jekyll-theme-time-machine`

其他第三方主题可用 `remote_theme: 作者/仓库名` 引入（需要 `jekyll-remote-theme` 插件）。

---

## 故障排查

| 现象 | 原因 & 解决 |
|------|-------------|
| 访问 404 | 仓库名拼错；Pages 未启用；构建还没完成（等 3 分钟）|
| 页面无样式 | 项目站点没设 `baseurl`；或 `_config.yml` 里 `url` 写错 |
| Actions 红叉 ❌ | 点进去看日志，常见是 `_config.yml` YAML 缩进错误或 Liquid 语法错误 |
| 新文章不出现 | 文件名日期格式不对；日期在未来（Jekyll 默认不发布未来文章）；Front Matter 缺失 |
| 中文 URL 乱码 | 文件名用英文 slug，`title` 用中文即可 |
| 本地 `bundle install` 报错 | 系统 Ruby 太旧，建议用 `rbenv` 或 `brew install ruby` 安装 Ruby 3.x |
