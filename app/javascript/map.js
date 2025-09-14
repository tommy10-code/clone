window.initMap = () => {
  const el = document.getElementById("map");
  const map = new google.maps.Map(el, { center: { lat: 35.1709, lng: 136.8815 }, zoom: 14 });

  let markers = [];
  const clearMarkers = () => { markers.forEach(m => m.setMap(null)); markers = []; };

  const createShopMarker = shop => {
    const lat = Number(shop.latitude), lng = Number(shop.longitude);
    if (!Number.isFinite(lat) || !Number.isFinite(lng)) return;
    const marker = new google.maps.Marker({ position: { lat, lng }, map });
    const info = new google.maps.InfoWindow({
      content: `
        <div class="p-3">
          <h3 class="mb-2 text-gray-800 text-sm font-bold">${shop.title}</h3>
          <div class="mb-1 text-xs text-gray-600">カテゴリ：${shop.category_name}</div>
          <div class="mb-3 text-xs text-gray-600">シーン：${shop.scenes_name}</div>
          <button onclick="window.open('https://www.google.com/search?q=${encodeURIComponent(shop.title)}','_blank')"
                  class="bg-blue-500 hover:bg-blue-600 text-white px-3 py-2 rounded text-xs w-full">Googleで検索</button>
        </div>`
    });
    marker.addListener("mouseover", () => info.open({ anchor: marker, map }));
    return marker;
  };

  const updateMarkers = shops => {
    clearMarkers();
    shops.forEach(s => { const m = createShopMarker(s); if (m) markers.push(m); });
  };

  const loadShops = url =>
    fetch(url, { headers: { Accept: "application/json" } })
      .then(r => r.json()).then(updateMarkers)
      .catch(e => console.error("[shops fetch error]:", e));

  // 初期表示：現在のURLパラメータと同条件でピン表示
  loadShops("/shops.json" + window.location.search);

  // 検索用に公開：カテゴリ名で絞り込み
  window.performSearch = category =>
    loadShops(`/shops.json?q[category_name_cont]=${encodeURIComponent(category)}`);

  // 現在地マーカー（任意）
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      pos => new google.maps.Marker({
        position: { lat: pos.coords.latitude, lng: pos.coords.longitude },
        map,
        icon: { url: "https://maps.google.com/mapfiles/ms/icons/blue-dot.png" }
      }),
      err => { console.error("位置情報取得失敗:", err); alert("位置情報を取得できませんでした。"); }
    );
  }
};
