import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "output"]

  update() {
    const length = this.inputTarget.value.length
    this.outputTarget.textContent = `現在の文字数 ${length}`
  }
}