import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["source"];

  copyToClipboard(event) {
    event.preventDefault();
    const text = event.currentTarget.getAttribute("data-clipboard-text");
    navigator.clipboard.writeText(text).then(() => {
      alert("Copied to clipboard!");
    }).catch(err => {
      console.error("Failed to copy: ", err);
    });
  }
}