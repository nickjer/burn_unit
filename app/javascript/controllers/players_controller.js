import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="players"
export default class extends Controller {
  static targets = [ "player" ]
  connect() {
  }

  playerTargetConnected(element) {
    this.sortElements(this.playerTargets).forEach(this.appendElement)
  }

  sortElements(playerElements) {
    return Array.from(playerElements).sort(this.compareElements)
  }

  compareElements(firstElement, secondElement) {
    const firstValue = firstElement.dataset.sortBy
    const secondValue = secondElement.dataset.sortBy
    return firstValue.localeCompare(secondValue)
  }

  appendElement = child => this.element.append(child)
}
