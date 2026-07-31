import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// げーむかいしボタン押下時に暗転演出を挟んでからゲスト作成→しりとり会場へ遷移する
export default class extends Controller {
  static targets = ["overlay"]

  start(event) {
    event.preventDefault()

    const url = event.currentTarget.href
    this.overlayTarget.classList.remove("opacity-0")

    setTimeout(() => {
      const token = document.querySelector('meta[name="csrf-token"]').content

      fetch(url, {
        method: "POST",
        headers: { "X-CSRF-Token": token, Accept: "text/html" },
        credentials: "same-origin",
      }).then((response) => {
        Turbo.visit(response.url)
      })
    }, 800)
  }
}
