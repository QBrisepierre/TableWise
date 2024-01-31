import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu-dropdown"
export default class extends Controller {
  static targets = ["menu"]
  connect() {
    console.log(this.menuTarget)
  }

  open() {
    this.menuTarget.classList.remove("hidden")
  }

  close() {
    this.menuTarget.classList.add("hidden")

  }
}
