import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"]

  update(event) {
    const length = event.target.value.length
    this.outputTarget.textContent = `現在の文字数 ${length}`
  }
}