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
    this.profilTarget.classList.add("opacity-0")
  }

  toggle() {
    this.profilTarget.classList.toggle("hidden")
    setTimeout(() => {
    this.profilTarget.classList.toggle("opacity-0")
    })
  }
}
