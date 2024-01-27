import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modal", "blur", "phone"]

  connect(){
    console.log(this.Target)
  }

  open() {
    event.preventDefault();
    this.modalTarget.classList.remove("hidden")
    this.blurTarget.classList.add("blur-sm", "brightness-50")
    document.body.style.overflow = 'hidden';
  }

  close() {
    this.modalTarget.classList.add("hidden")
    this.blurTarget.classList.remove("blur-sm", "brightness-50", "overflow-hidden")
    document.body.style.overflow = 'auto';
  }

}
