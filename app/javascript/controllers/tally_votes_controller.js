import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tally-votes"
export default class extends Controller {
  static outlets = [ "player" ]

  connect() {
  }

  playerOutletConnected(outlet, element) {
    const totalVotes = this.playerOutlets.reduce(
      (sum, player) => sum + player.votedValue, 0
    )
    if (totalVotes > 1) { this.element.disabled = false }
  }
}
