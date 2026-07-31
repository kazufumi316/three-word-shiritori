import { Controller } from "@hotwired/stimulus"

// CPUの返答を「あいての単語 → セリフ(2〜3秒表示) → 次のおだい」の順で段階的に表示する
export default class extends Controller {
  static targets = ["cpuWord", "comment", "nextTurn", "giveUp", "endButtons"]
  static values = { animate: Boolean }

  connect() {
    if (!this.animateValue) return

    this.reveal(this.cpuWordTarget, 200)
    this.reveal(this.commentTarget, 1000)

    const finalDelay = 1000 + 2400
    if (this.hasNextTurnTarget) this.reveal(this.nextTurnTarget, finalDelay)
    if (this.hasEndButtonsTarget) this.reveal(this.endButtonsTarget, finalDelay)
  }

  // あきらめるボタン押下時、対局終了時と同じ「おわり/もういちど」ボタンに切り替える
  giveUp() {
    this.giveUpTarget.classList.add("hidden")
    this.endButtonsTarget.classList.remove("hidden")
  }

  reveal(target, delay) {
    setTimeout(() => target.classList.remove("opacity-0"), delay)
  }
}
