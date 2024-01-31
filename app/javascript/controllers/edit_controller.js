import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from 'stimulus-use'

// Connects to data-controller="edit"
export default class extends Controller {
  static targets = ["edit"]
  connect() {
    console.log(this.editTarget)
  }

  connect() {
    useClickOutside(this)
  }

  clickOutside(event) {
    this.editTarget.classList.add("hidden")
  }

  toggle() {
    this.editTarget.classList.toggle("hidden")
  }
}
