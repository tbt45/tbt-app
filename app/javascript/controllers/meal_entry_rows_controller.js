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

    const row = event.target.closest("[data-meal-entry-rows-target='row']")
    const caloriesField = row.querySelector("[data-meal-entry-rows-target='calories']")
    caloriesField.value = template.calories
  }

  clearRow(row) {
    row.querySelectorAll("input:not([type='hidden'])").forEach((input) => {
      if (input.name.includes("[quantity]")) {
        input.value = 1
      } else {
        input.value = ""
      }
    })
    row.querySelectorAll("select").forEach((select) => {
      select.selectedIndex = 0
    })
  }
}
