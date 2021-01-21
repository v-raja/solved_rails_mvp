import $ from 'jquery';
import 'select2';                       // globally assign select2 fn to $ element
import 'select2/dist/css/select2.css'

import '../stylesheets/select2_confirm_niche.scss';  // optional if you have css loader

var algolia = algoliasearch(
  process.env.ALGOLIA_APP_ID,
  process.env.ALGOLIA_ADMIN_API_KEY
);

var index = algolia.initIndex('niches_development');

$(document).on('turbolinks:load', function() {
    document.getElementById("select-niches").focus();
    // $('#select-niches').select2('focus');
    $('#select-niches').select2({
      placeholder: 'Select two niches to continue',
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
          return { query: params.term, hitsPerPage: 8, page: (params.page || 1) - 1, highlightPreTag: '<strong>', highlightPostTag: '</strong>', attributesToSnippet: ['description:40'], snippetEllipsisText: '...' };
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
      closeOnSelect: false,
      escapeMarkup: function (markup) { return markup; },
      minimumInputLength: 3,
      cache: false,
      templateSelection: function(contact) {
        if (contact.text == 'Choose a contact'){
        	return "Choose a contact";
        } else {
          return contact.title;
        }
        // return contact._highlightResult.title.value;
      },
      templateResult: function(niche_res) {
      	if (niche_res.text == 'Searching…'){
        	return niche_res.text;
        } else {
          return '<div class="flex flex-wrap">' +
                  '<div class="w-full font-medium uppercase mt-1 text-gray-800">' +
                    niche_res.type +
                  '</div>' +
                  '<div class="w-full text-black leading-tight text-base font-medium mt-1">' +
                    niche_res._highlightResult.title.value +
                  '</div>' +
                  '<div class="w-full text-xs mt-2 text-gray-600">' +
                    'Description' +
                  '</div>' +
                  '<div class="w-full text-sm">' +
                     niche_res._snippetResult.description.value +
                  '</div>' +
                '</div>'
        }
      }
    });


});



