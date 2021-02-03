import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css'

$(document).on('turbolinks:load', function() {
  if (document.getElementById("select_community")) {

    var algolia;
    if (gon.ffi) {
      algolia = algoliasearch(
        process.env.ALGOLIA_APP_ID,
        process.env.ALGOLIA_SEARCH_KEY, {
          headers: {
            'X-Algolia-UserToken': gon.current_user_id
          }
        }
      );
    } else {
      algolia = algoliasearch(
        process.env.ALGOLIA_APP_ID,
        process.env.ALGOLIA_SEARCH_KEY
      );
    }

    var index = algolia.initIndex('niches_' + process.env.RAILS_ENV);

    $('#general_tags').select2({
      placeholder: 'marketing, sales, crm, team management, engineering, human resources',
      multiple: true,
      tags: true
    });

    $('#niche_specific_tags').select2({
      placeholder: 'design request management, classroom management, online learning',
      multiple: true,
      tags: true,
      language: {
        noResults: function() {
          return 'No tags yet';
        },
      },
    });

    $('#select_community').select2({
      language: {
        inputTooShort: function() {
          return 'Please enter 3 or more character to search';
        },
      },
      closeOnSelect: false,
      placeholder: 'Search for an industry / occupation',
      multiple: true,
      maximumSelectionLength: 8,
      ajax: {
        // Custom transport to call Algolia's API
        transport: function(params, success, failure) {
          var queryParams = params.data;
          var q = queryParams.query;
          delete queryParams.query;
          index.search(q, queryParams).then(success, failure);
        },
        // build Algolia's query parameters (with page starting at 0)
        data: function(params) {
          return { query: params.term, hitsPerPage: 8, page: (params.page || 1) - 1, highlightPreTag: '<strong>', highlightPostTag: '</strong>' };
          // filters: `is_postable=1`
        },

        // return Algolia's results
        processResults: function(data) {
          return {
            results: data.hits.map(function(item) {
                    return {...item,
                            id : item.objectID,
                    };
                  }),
            pagination: {
              more: data.page + 1 < data.nbPages
            }
          };
        }
      },
      escapeMarkup: function (markup) { return markup; },
      // minimumInputLength: 3,
      cache: false,
      templateSelection: function(contact) {
        if (contact.text == 'Choose a contact'){
          return "Choose a contact";
        } else {
          return contact.title;
        }
        // return contact._highlightResult.title.value;
      },
      templateResult: function(contact) {
        if (contact.text == 'Searching…'){
          return contact.text;
        } else {
          return "<div class='select2-user-result'>" +
                contact._highlightResult.title.value +
                '<br />' +
                '<small class="text-muted">' + contact.type + '</small>' +
                "</div>";
        }
      }
    });
  }
});
