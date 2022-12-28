import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sorter"
export default class extends Controller {
  static values = {  target: String  }
  static targets = [ "item" ]

  initialize() {
    this.observer = new MutationObserver(this.mutation)
  }

  connect() {
  }

  itemTargetConnected(element) {
    this.sortElements(this.itemTargets).forEach(this.appendElement)
    const targetElement = element.querySelector(this.targetValue)
    this.observer.observe(targetElement, { childList: true })
  }

  sortElements(itemElements) {
    if (this.isSorted(itemElements)) {
      return []
    } else {
      return Array.from(itemElements).sort(this.compareElements)
    }
  }

  isSorted = list => {
    return list.every((item, i) => {
      return i === 0 || this.compareElements(list[i - 1], item) <= 0
    })
  }

  compareElements = (firstElement, secondElement) => {
    const firstValue = firstElement.querySelector(this.targetValue).innerText
    const secondValue = secondElement.querySelector(this.targetValue).innerText
    return firstValue.localeCompare(secondValue)
  }

  appendElement = child => {
    this.element.append(child)
  }

  mutation = () => {
    this.sortElements(this.itemTargets).forEach(this.appendElement)
  }
}
