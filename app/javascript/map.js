document.addEventListener("turbo:load", async () => {
  //RailsのERB（HTML）内にある <div id="map"> という要素を取得している
  const el = document.getElementById("map");
  if (!el) return;

  // mapsライブラリからMapクラス InfoWindowクラス   markerライブラリからMarkerクラス
  const { Map, InfoWindow } = await google.maps.importLibrary("maps");
  const { Marker } = await google.maps.importLibrary("marker");

  //地図インスタンスを作成
  const nagoya = { lat: 35.1709, lng: 136.8815 };
  const map = new Map(el, { center: nagoya, zoom: 15, gestureHandling: "greedy" });

  // マーカーを作成するための条件 shopを引数（Railsなどから受け取った1件分のお店データ）
  const createShopMarker = (shop) => {
    const lat = Number(shop.latitude), lng = Number(shop.longitude);
    if (!Number.isFinite(lat) || !Number.isFinite(lng)) return;

  //マーカーインスタンスを作成 mapは地図インスタンスを作成したときのmapでここにマーカーを指している
    const marker = new Marker({ position: { lat, lng }, map });
  //吹き出しを作成
    const info = new InfoWindow({
      content: `
        <div class="p-3">
          <h3 class="mb-2 text-gray-800 text-sm font-bold">${shop.title}</h3>
          <div class="mb-1 text-xs text-gray-600">カテゴリ：${shop.category_name ?? ""}</div>
          <div class="mb-3 text-xs text-gray-600">シーン：${shop.scenes_name ?? ""}</div>
          <button onclick="window.open('https://www.google.com/search?q=${encodeURIComponent(shop.title)}','_blank')"
                  class="bg-blue-500 hover:bg-blue-600 text-white px-3 py-2 rounded text-xs w-full">
            Googleで検索
          </button>
        </div>`
    });
    marker.addListener("mouseover", () => info.open({ anchor: marker, map }));
    marker.addListener("click", () => info.open({ anchor: marker, map }));
    marker.addListener("click", (e) => map.setCenter(e.latLng));
    return marker;
  };

  // 一度マーカーをリセットする
  let markers = [];
  const clearMarkers = () => { markers.forEach(m => m.setMap(null)); markers = []; };

  // 一度マーカーの情報を削除して、新しくマーカーを描写
  const updateMarkers = (shops) => {
    clearMarkers();
    (shops || []).forEach(s => {
      const m = createShopMarker(s);
      if (m) markers.push(m);
    });
  };

  // Railsからshopデータを取得,updateMarkersの関数実行
  const loadShops = (url) =>
    fetch(url, { headers: { Accept: "application/json" } })
      .then(r => r.json())
      .then(updateMarkers)
      .catch(e => console.error("[shops fetch error]:", e));

  // loadShopsの関数を実行
  loadShops("/shops.json" + window.location.search);

  // このコードも意味も知りたい！現在地マーカーの取得
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      pos => new Marker({
        position: { lat: pos.coords.latitude, lng: pos.coords.longitude },
        map,
        // 旧Markerアイコン指定（AdvancedMarker化は後で対応でもOK）
        icon: { url: "https://maps.google.com/mapfiles/ms/icons/blue-dot.png" }
      }),
      err => { console.error("位置情報取得失敗:", err);}
    );
  }
});
