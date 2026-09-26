---
layout: page
title: 分类
permalink: /categories/
---

按分类浏览全部文章。

{% assign cats = site.categories | sort %}
{% for cat in cats %}
{% assign cname = cat[0] %}
{% assign cposts = cat[1] %}
<section class="group-block" id="cat-{{ cname | url_encode }}">
  <h2>{{ cname }}<span class="group-count">{{ cposts.size }} 篇</span></h2>
  <ul class="archive-list">
    {% for post in cposts %}
    <li>
      <span class="archive-date">{{ post.date | date: '%m-%d' }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      {%- if post.tags.size > 0 -%}
      <small class="archive-tags">{% for t in post.tags %}<code>{{ t }}</code> {% endfor %}</small>
      {%- endif -%}
    </li>
    {% endfor %}
  </ul>
</section>
{% endfor %}
