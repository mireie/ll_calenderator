import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  timeout = null

  submit(event) {
    event.preventDefault();

    clearTimeout(this.timeout);

    this.timeout = setTimeout(() => {
      this.element.submit();
    }, 300); // 300ms debounce
  }
}
