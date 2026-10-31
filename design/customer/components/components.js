/*
 * prepay-app 공통 컴포넌트
 *
 * 화면 파일에서 아래 태그로 씁니다. (스크립트는 각 화면 맨 아래에서 불러와요)
 *   <app-tab-bar tab="home"></app-tab-bar>              tab = home | shop | wallet | like | my
 *   <store-row store="하루카페 강남점" cat="카페" area="서울시 행복구"
 *              rate="30%" dist="88m" likes="999" liked="n" value="y"
 *              tone="a" kind="cafe" href="../04-store-charge/04-01-store.html"></store-row>
 *   <store-tile store="하루카페 강남점" cat="카페" dist="88m" rate="30%"
 *               tone="a" kind="cafe" liked="n" href="..."></store-tile>
 *
 *   tone = a | b | c | d (업종 썸네일 색)   kind = cafe | food | bakery | beauty | shop
 *   liked, value = y | n
 *
 * 색·크기는 tokens/tokens.css 와 같은 값을 씁니다. 바꿀 때는 두 곳을 함께 고쳐 주세요.
 */
(function () {
  'use strict';

  // 이 파일 위치(components/) 기준으로 프로젝트 루트를 찾아 화면 경로를 만듭니다.
  var ROOT = new URL('../', document.currentScript.src);
  function screen(path) {
    return new URL('screens/' + path, ROOT).href;
  }

  var SCREENS = {
    home: screen('02-home/02-01-home.html'),
    shop: screen('03-shop-likes/03-01-shop.html'),
    wallet: screen('05-wallet-pay/05-01-wallet.html'),
    like: screen('03-shop-likes/03-04-likes.html'),
    my: screen('09-my/09-01-my.html'),
    store: screen('04-store-charge/04-01-store.html')
  };

  var TONES = {
    a: { bg: '#FFF1E8', fg: '#A34B12' },
    b: { bg: '#EEF2FF', fg: '#3A55B0' },
    c: { bg: '#ECF7EF', fg: '#2C7445' },
    d: { bg: '#F3EFFC', fg: '#5E46A6' }
  };

  var KIND_ICONS = {
    cafe: '<path d="M5 9h11v5a5 5 0 01-5 5h-1a5 5 0 01-5-5z"/><path d="M16 10h1.5a2.5 2.5 0 010 5H16"/><path d="M8.5 3.5v3M12.5 3.5v3"/>',
    food: '<path d="M7 3v8M5 3v5a2 2 0 004 0V3M7 11v10"/><path d="M17 3c-2 1.5-3 4-3 7h3v11"/>',
    bakery: '<path d="M4 19h16v-5H4z"/><path d="M4 14c1.3 1 2.7 1 4 0s2.7-1 4 0 2.7 1 4 0 2.7-1 4 0"/><path d="M8 10V7.5M12 10V5.5M16 10V7.5"/>',
    beauty: '<circle cx="6.5" cy="7" r="2.5"/><circle cx="6.5" cy="17" r="2.5"/><path d="M8.6 8.4L20 18M8.6 15.6L20 6"/>',
    shop: '<path d="M5 8h14l-1 12H6z"/><path d="M9 8V6.5a3 3 0 016 0V8"/>'
  };

  var HEART = '<path d="M12 20s-7.5-4.6-7.5-10.2A4.3 4.3 0 0112 7.2a4.3 4.3 0 017.5 2.6C19.5 15.4 12 20 12 20z"/>';

  function esc(v) {
    return String(v == null ? '' : v)
      .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;').replace(/'/g, '&#39;');
  }

  function yes(v, fallback) {
    if (v == null) return fallback;
    return v === 'y' || v === 'true' || v === '';
  }

  function kindIcon(kind, size, strokeWidth) {
    var paths = KIND_ICONS[kind] || KIND_ICONS.cafe;
    return '<svg width="' + size + '" height="' + size + '" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="' + strokeWidth + '" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' + paths + '</svg>';
  }

  function attrs(el) {
    var tone = TONES[el.getAttribute('tone')] || TONES.a;
    var liked = yes(el.getAttribute('liked'), false);
    return {
      store: el.getAttribute('store') || '하루카페 강남점',
      cat: el.getAttribute('cat') || '카페',
      area: el.getAttribute('area') || '서울시 행복구',
      rate: el.getAttribute('rate') || '30%',
      dist: el.getAttribute('dist') || '88m',
      likes: el.getAttribute('likes') || '999',
      href: el.getAttribute('href') || SCREENS.store,
      kind: el.getAttribute('kind') || 'cafe',
      value: yes(el.getAttribute('value'), true),
      tone: tone,
      liked: liked,
      heartFill: liked ? '#191F28' : 'none',
      heartColor: liked ? '#191F28' : '#6B7684'
    };
  }

  /* ---------- 하단 탭바 ---------- */
  var TAB_ITEMS = [
    { key: 'home', label: '홈', icon: '<path d="M4 11l8-7 8 7"/><path d="M6 9.5V20h12V9.5"/><path d="M10 20v-5h4v5"/>' },
    { key: 'shop', label: '가게찾기', icon: '<path d="M12 21s-7-6.2-7-11a7 7 0 0114 0c0 4.8-7 11-7 11z"/><circle cx="12" cy="10" r="2.5"/>' },
    { key: 'wallet', label: '내 가게', icon: '<path d="M4 8h14a2 2 0 012 2v8a2 2 0 01-2 2H6a2 2 0 01-2-2V8z"/><path d="M4 8l11-3.5V8"/><path d="M15.5 14h1.5"/>' },
    { key: 'like', label: '좋아요', icon: HEART },
    { key: 'my', label: '내 정보', icon: '<circle cx="12" cy="8.5" r="3.8"/><path d="M4.5 20a7.5 7.5 0 0115 0"/>' }
  ];

  class AppTabBar extends HTMLElement {
    static get observedAttributes() { return ['tab']; }
    connectedCallback() { this.style.display = 'block'; this.style.flex = 'none'; this.render(); }
    attributeChangedCallback() { if (this.isConnected) this.render(); }
    render() {
      var current = this.getAttribute('tab') || 'home';
      var links = TAB_ITEMS.map(function (t) {
        var on = t.key === current;
        return '<a href="' + SCREENS[t.key] + '"' + (on ? ' aria-current="page"' : '') +
          ' style="flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:3px;text-decoration:none;color:' + (on ? '#191F28' : '#636D7A') + '">' +
          '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="' + (on ? '2.2' : '1.7') + '" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' + t.icon + '</svg>' +
          '<span style="font-size:12px;font-weight:' + (on ? '700' : '400') + '">' + t.label + '</span></a>';
      }).join('');
      this.innerHTML = '<nav aria-label="주요 메뉴" style="width:390px;height:84px;box-sizing:border-box;background:#FFFFFF;border-top:1px solid #E5E8EB;padding:6px 8px 22px;display:flex;font-family:\'Noto Sans KR\',sans-serif;color:#191F28">' + links + '</nav>';
    }
  }

  /* ---------- 가게 목록 행 ---------- */
  class StoreRow extends HTMLElement {
    connectedCallback() { this.style.display = 'block'; this.render(); }
    render() {
      var a = attrs(this);
      this.innerHTML =
        '<div style="width:100%;height:104px;box-sizing:border-box;display:flex;align-items:center;gap:4px;font-family:\'Noto Sans KR\',sans-serif;color:#191F28;background:#FFFFFF">' +
          '<a href="' + esc(a.href) + '" style="flex:1;min-width:0;display:flex;align-items:center;gap:14px;text-decoration:none;color:#191F28">' +
            '<div style="flex:none;width:68px;height:68px;border-radius:18px;background:' + a.tone.bg + ';color:' + a.tone.fg + ';display:flex;align-items:center;justify-content:center">' + kindIcon(a.kind, 30, 1.6) + '</div>' +
            '<div style="flex:1;min-width:0;display:flex;flex-direction:column;gap:3px">' +
              (a.value ? '<span style="font-size:12px;font-weight:500;color:#4E5968">가성비 가게</span>' : '') +
              '<span style="font-size:16px;font-weight:700;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">' + esc(a.store) + '</span>' +
              '<span style="font-size:13px;color:#636D7A;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">' + esc(a.cat) + ' · ' + esc(a.area) + '</span>' +
              '<div style="display:flex;align-items:center;gap:8px;margin-top:3px">' +
                '<span style="font-size:12px;font-weight:500;color:#C42726;background:#FFF0F0;border-radius:6px;padding:2px 7px">최대 ' + esc(a.rate) + '</span>' +
                '<span style="font-size:13px;color:#636D7A">' + esc(a.dist) + ' · 찜 ' + esc(a.likes) + '</span>' +
              '</div>' +
            '</div>' +
          '</a>' +
          '<button type="button" aria-label="' + esc(a.store) + ' 찜하기" aria-pressed="' + a.liked + '" style="flex:none;width:44px;height:44px;border:0;background:transparent;padding:0;display:flex;align-items:center;justify-content:center;color:' + a.heartColor + ';cursor:pointer">' +
            '<svg width="22" height="22" viewBox="0 0 24 24" fill="' + a.heartFill + '" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' + HEART + '</svg>' +
          '</button>' +
        '</div>';
    }
  }

  /* ---------- 가게 타일 ---------- */
  class StoreTile extends HTMLElement {
    connectedCallback() { this.style.display = 'block'; this.style.flex = 'none'; this.render(); }
    render() {
      var a = attrs(this);
      this.innerHTML =
        '<div style="width:160px;height:244px;box-sizing:border-box;position:relative;font-family:\'Noto Sans KR\',sans-serif;color:#191F28">' +
          '<a href="' + esc(a.href) + '" style="display:flex;flex-direction:column;gap:10px;text-decoration:none;color:#191F28">' +
            '<div style="width:160px;height:160px;border-radius:20px;background:' + a.tone.bg + ';color:' + a.tone.fg + ';display:flex;align-items:center;justify-content:center">' + kindIcon(a.kind, 52, 1.3) + '</div>' +
            '<div style="display:flex;flex-direction:column;gap:2px">' +
              '<span style="font-size:15px;font-weight:700;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">' + esc(a.store) + '</span>' +
              '<span style="font-size:13px;color:#636D7A;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">' + esc(a.cat) + ' · ' + esc(a.dist) + '</span>' +
              '<span style="align-self:flex-start;margin-top:5px;font-size:12px;font-weight:500;color:#C42726;background:#FFF0F0;border-radius:6px;padding:2px 7px">최대 ' + esc(a.rate) + '</span>' +
            '</div>' +
          '</a>' +
          '<button type="button" aria-label="' + esc(a.store) + ' 찜하기" aria-pressed="' + a.liked + '" style="position:absolute;top:8px;right:8px;width:36px;height:36px;border-radius:18px;border:0;background:#FFFFFF;padding:0;display:flex;align-items:center;justify-content:center;color:' + a.heartColor + ';cursor:pointer">' +
            '<svg width="18" height="18" viewBox="0 0 24 24" fill="' + a.heartFill + '" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' + HEART + '</svg>' +
          '</button>' +
        '</div>';
    }
  }

  customElements.define('app-tab-bar', AppTabBar);
  customElements.define('store-row', StoreRow);
  customElements.define('store-tile', StoreTile);
})();
