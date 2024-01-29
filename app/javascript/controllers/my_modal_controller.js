import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="my-modal"
export default class extends Controller {
  static targets = ["modalHistory", "blur"]
  connect() {
    console.log(this)
  }
  
  openModal(){
    this.modalHistoryTarget.classList.remove("hidden")
    this.blurTarget.classList.add("blur-sm", "brightness-50")
  }

  closeModal() {
    this.modalHistoryTarget.classList.add("hidden")
    this.blurTarget.classList.remove("blur-sm", "brightness-50")
  }
  
}
