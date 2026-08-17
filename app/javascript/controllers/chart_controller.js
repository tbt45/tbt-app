import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"

Chart.register(...registerables)

export default class extends Controller {
  static targets = [ "canvas" ]
  static values = {
    labels: Array,
    datasets: Array
  }

  connect() {
    this.renderChart()
  }

  disconnect() {
    this.destroyChart()
  }

  labelsValueChanged() {
    if (this.chart) this.renderChart()
  }

  datasetsValueChanged() {
    if (this.chart) this.renderChart()
  }

  renderChart() {
    this.destroyChart()
    if (!this.hasCanvasTarget) return

    this.chart = new Chart(this.canvasTarget, {
      type: "line",
      data: {
        labels: this.labelsValue,
        datasets: this.datasetsValue
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: { mode: "index", intersect: false },
        plugins: {
          legend: { position: "bottom" }
        },
        scales: {
          y: { beginAtZero: true }
        }
      }
    })
  }

  destroyChart() {
    if (this.chart) {
      this.chart.destroy()
      this.chart = null
    }
  }
}
