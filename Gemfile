source "https://rubygems.org"

# 使用 github-pages gem 可以保证本地环境与 GitHub Pages 服务器完全一致
# 版本号见 https://pages.github.com/versions/
gem "github-pages", group: :jekyll_plugins

group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
  gem "jekyll-sitemap"
end

# Windows / JRuby 平台需要的时区数据
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Windows 下的文件监听性能优化
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Ruby 3.x 本地运行需要
gem "webrick", "~> 1.8"
