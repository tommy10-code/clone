// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./map"
import "./autocomplete"
//index.jsを読み込むことでStimulusが起動
import "./controllers"

document.addEventListener("turbo:visit", () => {
  document.getElementById("loading").classList.remove("hidden");
});

document.addEventListener("turbo:load", () => {
  document.getElementById("loading").classList.add("hidden");
});