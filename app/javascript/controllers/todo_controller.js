import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.addEventListener('turbo:submit-end', this.clearFormOnSuccess.bind(this))
  }

  disconnect() {
    document.removeEventListener('turbo:submit-end', this.clearFormOnSuccess.bind(this))
  }

  clearFormOnSuccess(event) {
    if (event.detail.success && event.target.closest('[data-controller="todo"]')) {
      const titleInput = event.target.querySelector('input[name="todo[title]"]')
      if (titleInput) {
        titleInput.value = ''
        titleInput.focus()
      }
    }
  }
}