import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggleMenu() {
    document.getElementById('menu').classList.toggle('open');
  }

  toggleTheme() {
    document.querySelector('body').classList.toggle('dark');
  }

  scrollToBottom() {
    document.querySelector('.container').scrollTop = 10000;
  }
}
