import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  handleSubmit() {
    this.input = document.getElementById('task_content');
    this.input.value = '';
    this.input.focus();
  }
}
