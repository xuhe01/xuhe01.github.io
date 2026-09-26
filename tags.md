---
layout: page
title: 标签
permalink: /tags/
---

按标签浏览全部文章。

{% assign tags = site.tags | sort %}
{% for tag in tags %}
{% assign tname = tag[0] %}
{% assign tposts = tag[1] %}
<section class="group-block" id="tag-{{ tname | url_encode }}">
  <h2>{{ tname }}<span class="group-count">{{ tposts.size }} 篇</span></h2>
  <ul class="archive-list">
    {% for post in tposts %}
    <li>
      <span class="archive-date">{{ post.date | date: '%m-%d' }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      <small class="archive-tags">{{ post.categories | join: ' · ' }}</small>
    </li>
    {% endfor %}
  </ul>
</section>
{% endfor %}
