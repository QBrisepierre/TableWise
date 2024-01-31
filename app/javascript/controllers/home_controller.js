import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home"
export default class extends Controller {
  static targets = ["home"]
  connect() {
  }

  open() {
    this.homeTarget.classList.remove("hidden")
    setTimeout(() => {
      this.homeTarget.classList.remove("opacity-0")
      })
  }

  close() {
    this.homeTarget.classList.add("opacity-0")
    setTimeout(() => {
      this.homeTarget.classList.add("hidden")
      }, "500")
  }
}
