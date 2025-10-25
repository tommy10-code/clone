import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  dismiss() {
    const checkbox = document.getElementById("hideBannerCheckbox");
    if ( checkbox?.checked ) {
        fetch("/onboarding", {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ hide_onboarding_banner: true })
    });
  }
  this.element.remove();
  }
}