import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="my-modal"
export default class extends Controller {
  static targets = ["modalHistory"]
  
  openModal(){
    this.modalHistoryTarget.classList.remove("hidden")
    document.body.style.overflow = 'hidden';
  }

  closeModal() {
    this.modalHistoryTarget.classList.add("hidden")
    document.body.style.overflow = 'auto';   
  }
  
}
