console.log("地図表示"); // (1) デバッグ用ログ。map.jsが読み込まれていることを確認するための出力。

// app/javascript/map.js
// ★ application.js で `import "./map"` されている前提
// (2) このファイルは application.js からインポートされ、ビルド後にブラウザで実行される。

const RED_ICON  = "https://maps.google.com/mapfiles/ms/icons/red-dot.png"; // (3) 通常表示（赤）のマーカーアイコンURL。
const BLUE_ICON = "https://maps.google.com/mapfiles/ms/icons/blue-dot.png"; // (4) 強調表示（青）のマーカーアイコンURL。

const markersById = {}; // shop.id -> marker // (5) 店舗IDをキー、対応するMarkerインスタンスを値に持つハッシュ。
let infoWindow; // (6) 使い回すInfoWindow（吹き出し）。1個を共有することで同時に複数開かないようにする。

// 重なりマーカーを円状にずらす（そのまま移植）
function spreadSamePositionMarkers(raw) { // (7) 同一座標に複数マーカーが重なる場合、少しずらして見やすくする関数。
  const groups = {}; // (8) 座標をキーにしたグループ（同一地点に属するデータの配列）を格納するハッシュ。
  
  raw.forEach((s) => { // (9) 全データを走査。
    const key = `${(+s.la).toFixed(6)},${(+s.ln).toFixed(6)}`; // (10) 緯度経度を小数6桁に丸め、同一点判定のキーにする。+は数値化。
    (groups[key] ||= []).push(s); // (11) null合体代入。groups[key]が未定義なら[]を入れてからpush。
  });

  const spread = []; // (12) ずらし後の出力配列。
  Object.values(groups).forEach((list) => { // (13) 各グループ（同一点の集合）ごとに処理。
    if (list.length === 1) { spread.push(list[0]); return; } // (14) 1件ならそのまま採用（ずらす必要なし）。
    const Rm = 12; // (15) 円の半径（メートル単位）。見た目と密集度で調整可能。
    const lat0 = list[0].la, lng0 = list[0].ln; // (16) グループの中心座標（基準点）。
    const latMeter = 1 / 111320; // (17) 緯度方向の「1メートルを度に直す係数」（地球上でほぼ一定）。
    const lngMeter = 1 / (111320 * Math.cos(lat0 * Math.PI / 180)); // (18) 経度方向は緯度により縮むためcos補正。
    list.forEach((s, i) => { // (19) グループ内の各点を円周上に等間隔で配置。
      const angle = (2 * Math.PI * i) / list.length; // (20) 角度（0〜2π）を等分。
      const dLat = Rm * latMeter * Math.sin(angle); // (21) メートル→度へ変換した緯度のずれ。
      const dLng = Rm * lngMeter * Math.cos(angle); // (22) メートル→度へ変換した経度のずれ。
      spread.push({ ...s, la: lat0 + dLat, ln: lng0 + dLng }); // (23) 元データを複製し、ずらした座標を設定して出力。
    });
  });
  return spread; // (24) ずらし済み配列を返す。
}

// 一覧タイトルと連動するための関数（そのまま移植）
function highlightMarker(id, marker, map) { // (25) 指定ID（または渡されたMarker）を強調表示し、地図を寄せる。
  Object.values(markersById).forEach((m) => m.setIcon(RED_ICON)); // (26) まず全マーカーを赤に戻す（リセット）。
  (marker || markersById[id])?.setIcon(BLUE_ICON); // (27) 対象マーカーだけ青に変更。optional chainingで存在チェック。

  const target = marker || markersById[id]; // (28) 以降で使う対象マーカーを変数に保持。
  if (!target) return; // (29) 見つからなければ何もしない（安全対策）。
  map.panTo(target.getPosition()); // (30) 対象マーカーの位置へ地図中心をパン。
  if (map.getZoom() < 15) map.setZoom(15); // (31) ズームが低ければ最小でも15まで寄せる（見つけやすくする）。
}

// ✅ Googleのcallback=initMap から呼ばせるために window に公開
window.initMap = function initMap() { // (32) Googleの<script>のcallback=initMapで呼ばれる、初期化の入口関数。
  const el = document.getElementById("map"); // (33) 地図を描画するDOM要素を取得。
  if (!el) return; // (34) 要素がないページでは何もしない（他ページ影響を防ぐ）。

  const map = new google.maps.Map(el, { // (35) 地図インスタンスを作成。第1引数:DOM要素、第2引数:オプション。
    zoom: 13, // (36) 初期ズームレベル。
    center: { lat: 35.170915, lng: 136.881537 }, // (37) 初期中心座標（名古屋駅付近の例）。
  });

  infoWindow = new google.maps.InfoWindow(); // (38) 共有InfoWindowを生成。内容は都度差し替える。

  const YOU_ICON = { // (39) 現在地マーカー用のカスタムシンボル設定。
    path: google.maps.SymbolPath.CIRCLE, // (40) 円形シンボルを使用。
    fillColor: "#2563eb", fillOpacity: 1, // (41) 塗り色と不透明度。
    strokeColor: "#ffffff", strokeWeight: 2, // (42) 縁取り色と線の太さ。
    scale: 7, // (43) シンボルのサイズ。
  };

  // 一覧タイトルのクリック連動をセット
  bindListClicks(map); // (44) 一覧側のリンククリックで該当マーカーを強調するイベントを仕込む。

  // 現在地ピンを追加（中心は動かさない）
  addCurrentLocationMarker(map, YOU_ICON); // (45) 位置情報許可されれば現在地マーカーを地図に追加。

  // ---- ここから @shops データ読込（JSONタグから取得）----
  let raw = []; // (46) 生の店舗配列（座標ずらし前）を入れる変数。
  const jsonEl = document.getElementById("shops-json"); // (47) <script id="shops-json" type="application/json"> を取得。
  if (jsonEl?.textContent) { // (48) optional chainingで安全に中身の有無を確認。
    try { raw = JSON.parse(jsonEl.textContent); } // (49) 中身の文字列を配列にパース。
    catch(e) { console.warn("shops-json parse error:", e); } // (50) JSONが壊れていた場合の保険ログ。
  }

  const data = spreadSamePositionMarkers(raw); // (51) 同一点マーカーの重なりをばらした配列を作成。

  data.forEach((s) => { // (52) 各店舗データごとにマーカーを作成して地図へ追加。
    const marker = new google.maps.Marker({ // (53) 新規マーカー作成。
      position: { lat: s.la, lng: s.ln }, // (54) マーカーの座標（ずらし後）。
      map, // (55) 表示先の地図。
      title: s.t, // (56) マーカーのタイトル（ツールチップ用）。
      icon: RED_ICON, // (57) 初期は赤アイコン。
    });

    // (58) InfoWindowに表示するHTML文字列（詳細リンク・カテゴリ・シーン・Google検索ボタン）。
    const content = `
      <div style="padding:6px; min-width:180px;">
        <div style="font-weight:600; margin-bottom:4px;">
          <a href="${s.detail}" target="_blank" rel="noopener noreferrer"
             class="text-inherit hover:text-blue-600 hover:underline">${s.t}</a>
        </div>
        ${s.cat ? `<div style="font-size:12px; color:#6b7280; margin-bottom:6px;">カテゴリ: ${s.cat}</div>` : ""}
        ${(s.scn && s.scn.length)
          ? `<div style="font-size:12px; color:#6b7280; margin-bottom:8px;">シーン: ${s.scn.join(" / ")}</div>`
          : ""}
        <a href="${s.url}" target="_blank" rel="noopener"
           style="display:inline-block; background:#2563eb; color:#fff; padding:4px 8px; border-radius:4px; font-size:12px; text-decoration:none;">
          Googleで検索
        </a>
      </div>
    `; // (59) ここまでがHTMLテンプレート文字列。

    marker.addListener("mouseover", () => { // (60) マウスオーバーで吹き出しを表示。
      infoWindow.setContent(content); // (61) 吹き出し内容を差し替え。
      infoWindow.open({ anchor: marker, map }); // (62) このマーカーをアンカーにして表示。
    });

    marker.addListener("click", () => highlightMarker(s.id, marker, map)); // (63) クリックで強調表示＆地図パン・ズーム。

    markersById[s.id] = marker; // (64) 後でID指定で参照できるよう、辞書に登録。
  });

  // 念のため最後にもう一度バインド（既存ロジック踏襲）
  bindListClicks(map); // (65) DOMの変化でリスナが剥がれている可能性への保険。二重登録防止は必要に応じて調整。
};

// === ここから細かいユーティリティ ===
function bindListClicks(map) { // (66) 一覧の店名リンクにイベントを付与し、該当マーカーを強調する。
  document.querySelectorAll(".js-shop-title").forEach((el) => { // (67) .js-shop-title を全て取得。
    el.addEventListener("click", (e) => { // (68) クリック時のイベントを設定。
      e.preventDefault(); // (69) 通常のリンク遷移を止める（画面遷移させない）。
      const id = Number(el.dataset.shopId); // (70) data-shop-id 属性から数値IDを取得。
      highlightMarker(id, null, map); // (71) マーカー参照はIDから辞書を使う（第2引数nullでID優先）。
    });
  });
}

function addCurrentLocationMarker(map, YOU_ICON) { // (72) 現在地マーカーを地図に追加する。
  if (!navigator.geolocation) return; // (73) ブラウザがGeolocation非対応なら何もしない。
  navigator.geolocation.getCurrentPosition( // (74) 現在地取得を非同期で実行。
    (pos) => { // (75) 成功時コールバック。
      const { latitude: lat, longitude: lng } = pos.coords; // (76) 緯度・経度を分割代入で取得。
      new google.maps.Marker({ // (77) 現在地用のマーカーを作成。
        position: { lat, lng }, // (78) 現在地の座標。
        map, // (79) 表示先の地図。
        icon: YOU_ICON, // (80) カスタムシンボル（青丸+白縁）。
        title: "現在地", // (81) ツールチップ。
        zIndex: google.maps.Marker.MAX_ZINDEX + 1, // (82) 他マーカーより前面に出す。
      });
    },
    (err) => console.warn("Geolocation error:", err), // (83) 失敗時は警告ログ。ユーザーが拒否した場合など。
    { enableHighAccuracy: true, timeout: 10000, maximumAge: 60000 } // (84) 高精度要求、タイムアウト、キャッシュ許容時間。
  );
}
