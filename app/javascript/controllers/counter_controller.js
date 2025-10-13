import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "output"]
  static values = { min: Number }

  update() {
    const length = this.inputTarget.value.length
    
    if ( length < this.minValue) {
      this.outputTarget.textContent = `あと ${this.minValue - length} 文字必要です`
      //this.outputTarget.classList.add("text-red-600")
      //this.outputTarget.classList.remove("text-green-600")
    } else {
    this.outputTarget.textContent = `OK!`
      //this.outputTarget.classList.add("text-green-600")
      //this.outputTarget.classList.remove("text-red-600")
    }
    this.outputTarget.classList.toggle("text-red-600", length < this.minValue)
    this.outputTarget.classList.toggle("text-green-600", length >= this.minValue)

  }
}