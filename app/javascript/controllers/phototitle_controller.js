import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log( "Hello world!" )
    console.log( this )
    //#this.element.textContent = "Hello World!"
  }
}

