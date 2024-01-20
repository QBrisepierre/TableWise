import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["profil"]

  toggle() {
    this.profilTarget.classList.toggle("hidden")
  }
}
