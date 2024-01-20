import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modal", "blur"]

  connect(){
    console.log(this.blurTarget)
  }

  open() {
    event.preventDefault();
    this.modalTarget.classList.remove("hidden")
    this.blurTarget.classList.add("blur-sm")
  }

  close() {
    this.modalTarget.classList.add("hidden")
    this.blurTarget.classList.remove("blur-sm")
  }
}
