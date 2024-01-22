import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from 'stimulus-use'

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["profil"]

  connect() {
    useClickOutside(this)
  }

  clickOutside(event) {
    this.profilTarget.classList.add("hidden")
  }

  toggle() {
    this.profilTarget.classList.toggle("hidden")
  }
}
