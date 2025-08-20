import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["total", "pending", "completed"]

  connect() {
    this.updateStats()
  }

  updateStats() {
    const todos = document.querySelectorAll('[data-todo-status]')
    let total = todos.length
    let completed = 0
    let pending = 0

    todos.forEach(todo => {
      if (todo.dataset.todoStatus === "completed") {
        completed++
      } else {
        pending++
      }
    })

    this.totalTarget.textContent = total
    this.pendingTarget.textContent = pending
    this.completedTarget.textContent = completed
  }

  // เรียกใช้เมื่อมีการเปลี่ยนแปลง todo
  refresh() {
    this.updateStats()
  }
}
