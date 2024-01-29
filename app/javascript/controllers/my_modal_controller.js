import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="my-modal"
export default class extends Controller {
  static targets = ["modalHistory"]
  connect() {
    
  }
  
  openModal(){
    this.modalHistoryTarget.classList.remove("hidden")

  }

  closeModal() {
    this.modalHistoryTarget.classList.add("hidden")

  }
  
}
