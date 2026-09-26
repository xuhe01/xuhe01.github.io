/* ============================================================
   站内搜索（Ctrl K / Cmd K）
   索引由 Jekyll 构建时生成于 /search.json，纯前端无依赖
   ============================================================ */
(function () {
  var overlay = document.getElementById('search-overlay');
  if (!overlay) return;
  var input = document.getElementById('search-input');
  var resultsEl = document.getElementById('search-results');
  var src = overlay.getAttribute('data-src');
  var index = null;
  var list = [];
  var pos = 0;

  function esc(s) {
    return String(s || '').replace(/[&<>"]/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c];
    });
  }

  function load(cb) {
    if (index) return cb();
    var x = new XMLHttpRequest();
    x.open('GET', src, true);
    x.onload = function () {
      try { index = JSON.parse(x.responseText); } catch (e) { index = []; }
      cb();
    };
    x.onerror = function () { index = []; cb(); };
    x.send();
  }

  function open() {
    overlay.classList.add('open');
    document.documentElement.style.overflow = 'hidden';
    input.value = '';
    render('');
    setTimeout(function () { input.focus(); }, 30);
  }

  function close() {
    overlay.classList.remove('open');
    document.documentElement.style.overflow = '';
  }

  function render(q) {
    load(function () {
      q = (q || '').trim().toLowerCase();
      var items = index;
      if (q) {
        items = index.filter(function (it) {
          return ((it.title || '') + ' ' + (it.excerpt || '') + ' ' + (it.content || ''))
            .toLowerCase().indexOf(q) > -1;
        });
      }
      list = items.slice(0, 20);
      pos = 0;
      if (!list.length) {
        resultsEl.innerHTML = '<p class="search-empty">没有找到与「' + esc(q) + '」相关的内容</p>';
        return;
      }
      resultsEl.innerHTML = list.map(function (it, i) {
        return '<a class="search-result' + (i === 0 ? ' active' : '') + '" href="' + it.url + '">'
          + '<div class="sr-top"><span class="sr-type">' + esc(it.type) + '</span>'
          + (it.date ? '<span class="sr-date">' + esc(it.date) + '</span>' : '')
          + '</div>'
          + '<div class="sr-title">' + esc(it.title) + '</div>'
          + '<div class="sr-excerpt">' + esc(it.excerpt) + '</div>'
          + '</a>';
      }).join('');
    });
  }

  function move(d) {
    var links = resultsEl.querySelectorAll('.search-result');
    if (!links.length) return;
    pos = (pos + d + links.length) % links.length;
    for (var i = 0; i < links.length; i++) {
      links[i].classList.toggle('active', i === pos);
    }
    links[pos].scrollIntoView({ block: 'nearest' });
  }

  document.addEventListener('keydown', function (e) {
    if ((e.metaKey || e.ctrlKey) && (e.key === 'k' || e.key === 'K')) {
      e.preventDefault();
      overlay.classList.contains('open') ? close() : open();
      return;
    }
    if (!overlay.classList.contains('open')) return;
    if (e.key === 'Escape') { close(); }
    else if (e.key === 'ArrowDown') { e.preventDefault(); move(1); }
    else if (e.key === 'ArrowUp') { e.preventDefault(); move(-1); }
    else if (e.key === 'Enter') {
      var a = resultsEl.querySelector('.search-result.active');
      if (a) window.location.href = a.getAttribute('href');
    }
  });

  var i, btns = document.querySelectorAll('[data-search-open]');
  for (i = 0; i < btns.length; i++) {
    btns[i].addEventListener('click', function (e) { e.preventDefault(); open(); });
  }
  var closes = document.querySelectorAll('[data-search-close]');
  for (i = 0; i < closes.length; i++) closes[i].addEventListener('click', close);

  overlay.addEventListener('mousedown', function (e) {
    if (e.target === overlay) close();
  });
  input.addEventListener('input', function () { render(input.value); });
})();
