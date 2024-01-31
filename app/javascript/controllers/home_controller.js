import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home"
export default class extends Controller {
  static targets = ["home"]
  connect() {
  }

  open() {
    this.homeTarget.classList.remove("hidden")
  }

  close() {
    this.homeTarget.classList.add("hidden")

  }
}
