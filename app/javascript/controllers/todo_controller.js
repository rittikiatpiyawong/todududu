import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Listen for all turbo events globally
    document.addEventListener('turbo:submit-end', this.handleTurboEvents.bind(this))
    document.addEventListener('turbo:before-stream-render', this.handleTurboEvents.bind(this))
    document.addEventListener('turbo:frame-load', this.handleTurboEvents.bind(this))
  }

  disconnect() {
    document.removeEventListener('turbo:submit-end', this.handleTurboEvents.bind(this))
    document.removeEventListener('turbo:before-stream-render', this.handleTurboEvents.bind(this))
    document.removeEventListener('turbo:frame-load', this.handleTurboEvents.bind(this))
  }

  handleTurboEvents(event) {
    console.log('Turbo event detected:', event.type) // Debug log
    
    // รีเฟรช stats
    setTimeout(() => {
      this.refreshStats()
    }, 200)

    // เคลียร์ฟอร์มถ้าเป็นการสร้าง todo ใหม่
    if (event.type === 'turbo:submit-end' && event.detail.success) {
      const form = event.target
      if (form && form.action && form.action.includes('/todos') && 
          (form.method === 'post' || form.querySelector('input[name="_method"]')?.value === 'post')) {
        const titleInput = form.querySelector('input[name="todo[title]"]')
        if (titleInput) {
          titleInput.value = ''
        }
      }
    }
  }

  refreshStats() {
    console.log('Refreshing stats...') // Debug log
    const statsController = document.querySelector('[data-controller="todo-stats"]')
    if (statsController) {
      const controller = this.application.getControllerForElementAndIdentifier(statsController, 'todo-stats')
      if (controller) {
        controller.refresh()
      }
    }
  }
}
