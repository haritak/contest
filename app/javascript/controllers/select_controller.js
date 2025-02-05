import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  // We bind the select to tom-select on connect
  connect() {
    const tom = new TomSelect(this.element, {
      hidePlaceholder: false,
      highlight: true,
      allowEmptyOption: true,
      maxOptions: 15,
      maxItems:1,
      render:{
        no_results:function(data,escape){
          return '<div class="no-results">Χμμ... αυτό δεν βρέθηκε: "'+escape(data.input)+'"</div>';
        },
      }
    });

  }
}
