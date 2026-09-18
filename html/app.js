/* LXR-FARMING — the plant card | © 2026 iBoss21 / LXRCore */
(function () {
  const $ = (id) => document.getElementById(id);
  const card = $('card');
  let L = {}, left = 0, timer = null, stages = { 1: 'seedling', 2: 'growing', 3: 'ripe' };
  const t = (k, vars) => { let s = L[k] || k.split('.').pop().replace(/_/g, ' '); if (vars) for (const v in vars) s = s.replace('%{' + v + '}', vars[v]); return s; };
  function tick() {
    if (left <= 0) { $('left').textContent = t('ui.ready'); return; }
    const m = Math.floor(left / 60), s = Math.floor(left % 60);
    $('left').textContent = t('ui.left', { time: `${m}:${String(s).padStart(2, '0')}` });
    left -= 1;
  }
  window.addEventListener('message', e => {
    const m = e.data || {};
    if (m.brand && m.brand.theme) document.documentElement.dataset.theme = m.brand.theme;
    if (m.locale) L = m.locale;
    if (m.lang) document.body.classList.toggle('lang-ka', m.lang === 'ka');
    if (m.action === 'show') {
      const p = m.payload || {};
      $('crop').textContent = t('crop.' + p.crop);
      $('stage').textContent = t('stage.' + stages[p.stage]);
      $('water').textContent = p.stage >= 3 ? '' : (p.watered ? t('ui.watered') : t('ui.dry'));
      $('meter').style.width = Math.round(((p.stage - 1) / 2) * 100) + '%';
      $('owner').textContent = p.mine === false ? t('ui.not_yours') : '';
      left = Number(p.left) || 0; tick(); clearInterval(timer); timer = setInterval(tick, 1000);
      card.classList.remove('lxr-hidden');
    }
    if (m.action === 'hide') { card.classList.add('lxr-hidden'); clearInterval(timer); }
  });
  if (window.__LXR_MOCK__) window.postMessage(window.__LXR_MOCK__, '*');
})();
