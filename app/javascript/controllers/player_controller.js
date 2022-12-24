import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="player"
export default class extends Controller {
  static values = {
    online: Boolean,
    voted: Boolean,
    judge: Boolean,
    me: Boolean,
    name: String,
    editUrl: String
  }

  static targets = [ "name", "edit" ]

  initialize() {
    this.element.classList.add("player")
  }

  connect() {
    let name
    if (this.judgeValue) {
      name = `<strong>${this.nameValue}</strong>`
    } else {
      name = this.nameValue
    }
    this.nameTarget.innerHTML =
      `${this.onlineElement()} ${this.votedElement()} ${name}`
    if (this.meValue) {
      this.editTarget.classList.replace("d-none", "d-inline")
    } else {
      this.editTarget.classList.replace("d-inline", "d-none")
    }
  }

  onlineElement() {
    return (this.onlineValue ? "🟢" : "🔴")
  }

  votedElement() {
    let icon = (this.votedValue ? "bi-check-square" : "bi-square")
    return `<i class="bi ${icon}"></i>`
  }
}
