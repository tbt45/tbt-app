import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "rows", "row" ]
  static values = { templates: Array }

  addRow(event) {
    event.preventDefault()
    const row = this.rowTarget.cloneNode(true)
    this.clearRow(row)
    this.rowsTarget.appendChild(row)
  }

  applyTemplate(event) {
    const name = event.target.value
    const template = this.templatesValue.find((item) => item.name === name)
    if (!template) return

    const row = event.target.closest("[data-exercise-entry-rows-target='row']")
    const caloriesField = row.querySelector("[data-exercise-entry-rows-target='caloriesBurned']")
    caloriesField.value = template.calories_burned

    const durationField = row.querySelector("[data-exercise-entry-rows-target='durationMinutes']")
    if (durationField && template.duration_minutes) {
      durationField.value = template.duration_minutes
    }
  }

  clearRow(row) {
    row.querySelectorAll("input:not([type='hidden'])").forEach((input) => {
      input.value = ""
    })
  }
}
