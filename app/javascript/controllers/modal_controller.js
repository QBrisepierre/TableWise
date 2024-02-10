import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modalNoshow", "modalImport"]
  static values = { index: String }

  openModalNoShow() {
    event.preventDefault();
    this.modalNoshowTarget.classList.remove("hidden")
    document.body.style.overflow = 'hidden';
  }

  closeModalNoShow() {
    this.modalNoshowTarget.classList.add("hidden")
    document.body.style.overflow = 'auto';
  }

  openModalImport() {
    event.preventDefault();
    this.modalImportTarget.classList.remove("hidden")
    document.body.style.overflow = 'hidden';
  }

  closeModalImport() {
    this.modalImportTarget.classList.add("hidden")
    document.body.style.overflow = 'auto';
  }


}
