---
layout: page
title: 归档
permalink: /archive/
---

{% comment %} 按年份分组列出所有文章 {% endcomment %}
{% assign posts_by_year = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}

{% for year in posts_by_year %}
## {{ year.name }} 年

<ul class="archive-list">
{% for post in year.items %}
  <li>
    <span class="archive-date">{{ post.date | date: "%m-%d" }}</span>
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    {% if post.tags.size > 0 %}
      <small class="archive-tags">
      {% for tag in post.tags %}<code>{{ tag }}</code> {% endfor %}
      </small>
    {% endif %}
  </li>
{% endfor %}
</ul>
{% endfor %}

---

共 **{{ site.posts | size }}** 篇文章。
