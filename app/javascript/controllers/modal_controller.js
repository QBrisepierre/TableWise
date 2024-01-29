import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modalNoshow", "blur", "modalHistory"]
  static values = { index: String }

  connect(){
    console.log(this.indexValue)
  }

  openModalNoShow() {
    event.preventDefault();
    this.modalNoshowTarget.classList.remove("hidden")
    this.blurTarget.classList.add("blur-sm", "brightness-50")
    document.body.style.overflow = 'hidden';
  }

  closeModalNoShow() {
    this.modalNoshowTarget.classList.add("hidden")
    this.blurTarget.classList.remove("blur-sm", "brightness-50", "overflow-hidden")
    document.body.style.overflow = 'auto';
  }

  openModalHistory(){
    event.preventDefault();
    this.modalHistoryTarget.classList.remove("hidden")

    document.body.style.overflow = 'hidden';
  }

  closeModalHistory() {
    this.modalHistoryTarget.classList.add("hidden")

    document.body.style.overflow = 'auto';
  }

}
