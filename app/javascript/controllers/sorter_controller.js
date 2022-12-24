import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sorter"
export default class extends Controller {
  static targets = [ "item" ]
  connect() {
  }

  itemTargetConnected(element) {
    this.sortElements(this.itemTargets).forEach(this.appendElement)
  }

  sortElements(itemElements) {
    return Array.from(itemElements).sort(this.compareElements)
  }

  compareElements(firstElement, secondElement) {
    const firstValue = firstElement.dataset.sortBy
    const secondValue = secondElement.dataset.sortBy
    return firstValue.localeCompare(secondValue)
  }

  appendElement = child => this.element.append(child)
}
