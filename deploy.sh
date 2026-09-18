#!/usr/bin/env bash
# ============================================================
# 一键部署博客到 GitHub Pages
# 用法:
#   ./deploy.sh              # 交互式（会引导浏览器登录）
#   GH_TOKEN=ghp_xxx ./deploy.sh   # 用 PAT 非交互部署
# ============================================================
set -euo pipefail
cd "$(dirname "$0")"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
ok()   { printf '\033[32m✔ %s\033[0m\n' "$*"; }
warn() { printf '\033[33m⚠ %s\033[0m\n' "$*"; }
die()  { printf '\033[31m✘ %s\033[0m\n' "$*" >&2; exit 1; }

command -v gh  >/dev/null || die "未找到 gh，请先 brew install gh"
command -v git >/dev/null || die "未找到 git"

# ---------- 1. 登录 ----------
bold "▶ 1/6 检查 GitHub 登录状态"
if ! gh auth status >/dev/null 2>&1; then
  if [ -n "${GH_TOKEN:-}" ]; then
    echo "$GH_TOKEN" | gh auth login --with-token
  else
    warn "尚未登录。即将打开浏览器完成授权（GitHub 不支持密码登录）。"
    gh auth login --hostname github.com --git-protocol https --web
  fi
fi
gh auth setup-git >/dev/null 2>&1 || true
USER="$(gh api user --jq .login)"
[ -n "$USER" ] || die "无法获取用户名"
ok "已登录为 $USER"

REPO="${USER}.github.io"
SITE_URL="https://${REPO}"

# ---------- 2. 替换占位符 ----------
bold "▶ 2/6 替换占位符 USERNAME → $USER"
if grep -rlq "USERNAME" --exclude-dir=.git --exclude=deploy.sh . 2>/dev/null; then
  grep -rl "USERNAME" --exclude-dir=.git --exclude=deploy.sh . | while read -r f; do
    sed -i '' "s/USERNAME/${USER}/g" "$f"
    echo "   已更新 $f"
  done
fi
# 填入 GitHub 账号里的公开名字/邮箱（如果有）
NAME="$(gh api user --jq '.name // empty')"
EMAIL="$(gh api user --jq '.email // empty')"
if [ -n "$NAME" ]; then
  sed -i '' "s/^author: .*/author: ${NAME}/" _config.yml
  sed -i '' "s/我是 \*\*你的名字\*\*/我是 **${NAME}**/" about.md
fi
if [ -n "$EMAIL" ]; then
  sed -i '' "s/^email: .*/email: ${EMAIL}/" _config.yml
  sed -i '' "s/your-email@example.com/${EMAIL}/g" about.md
fi
ok "配置已个性化"

# ---------- 3. Git 身份 ----------
bold "▶ 3/6 配置 Git 提交身份"
git config user.name  "${NAME:-$USER}"
git config user.email "${EMAIL:-${USER}@users.noreply.github.com}"
git add -A
git commit -qm "chore: personalize for ${USER}" || true
git branch -M main
ok "本地提交完成"

# ---------- 4. 创建远程仓库 ----------
bold "▶ 4/6 创建仓库 $REPO"
if gh repo view "$USER/$REPO" >/dev/null 2>&1; then
  warn "仓库已存在，跳过创建"
else
  gh repo create "$REPO" --public --description "我的博客 · Powered by Jekyll & GitHub Pages"
  ok "仓库已创建"
fi
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/${USER}/${REPO}.git"

# ---------- 5. 推送 ----------
bold "▶ 5/6 推送代码"
git push -u origin main --force-with-lease 2>/dev/null || git push -u origin main
ok "已推送到 https://github.com/${USER}/${REPO}"

# ---------- 6. 启用 Pages ----------
bold "▶ 6/6 启用 GitHub Pages（main 分支 / 根目录）"
if gh api "repos/${USER}/${REPO}/pages" >/dev/null 2>&1; then
  gh api -X PUT "repos/${USER}/${REPO}/pages" \
    -f build_type=legacy -f 'source[branch]=main' -f 'source[path]=/' >/dev/null
  warn "Pages 已存在，已更新配置"
else
  gh api -X POST "repos/${USER}/${REPO}/pages" \
    -f build_type=legacy -f 'source[branch]=main' -f 'source[path]=/' >/dev/null
  ok "Pages 已启用"
fi

# ---------- 等待首次构建 ----------
bold "⏳ 等待首次构建（通常 1~3 分钟）..."
for i in $(seq 1 30); do
  STATUS="$(gh api "repos/${USER}/${REPO}/pages" --jq .status 2>/dev/null || echo null)"
  HTTP="$(curl -s -o /dev/null -w '%{http_code}' "$SITE_URL" || echo 000)"
  printf '   [%02d] pages.status=%s  http=%s\n' "$i" "$STATUS" "$HTTP"
  if [ "$HTTP" = "200" ]; then break; fi
  sleep 10
done

echo
bold "🎉 部署完成"
echo "   站点地址 : $SITE_URL"
echo "   仓库地址 : https://github.com/${USER}/${REPO}"
echo "   构建日志 : https://github.com/${USER}/${REPO}/actions"
echo "   Pages 设置: https://github.com/${USER}/${REPO}/settings/pages"
[ "$HTTP" = "200" ] || warn "站点还没返回 200，稍等几分钟再刷新即可。"
