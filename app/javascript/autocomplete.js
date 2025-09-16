console.log('オートコンプリート')

window.initPlacesAutofill = () => {
  const shopTitleInput = document.getElementById('shop_title_autocomplete');
  if (!shopTitleInput) return;

  const autocomplete = new google.maps.places.Autocomplete(shopTitleInput, {
    componentRestrictions: { country: "jp" },
    fields: [
      "place_id",
      "geometry.location",
      "formatted_address",
      "address_components",
      "name",
    ],
  });

  autocomplete.addListener('place_changed', () => {
    const place = autocomplete.getPlace();
    if (!place) return;
    shopTitleInput.value = place.name || "";

    const address = place.formatted_address;
    const shopAddressInput = document.getElementById('shop_address');
    if (shopAddressInput) {shopAddressInput.value = address};
  });
}