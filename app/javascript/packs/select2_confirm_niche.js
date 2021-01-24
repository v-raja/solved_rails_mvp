import $ from 'jquery';
import 'select2';                       // globally assign select2 fn to $ element
import 'select2/dist/css/select2.css'

import '../stylesheets/select2_confirm_niche.scss';  // optional if you have css loader


$(document).on('turbolinks:load', function() {
  var loginEl = document.getElementById('turbolinkz');
  var userId = loginEl.dataset.turbolinkzId;

  const algolia = algoliasearch(
    process.env.ALGOLIA_APP_ID,
    process.env.ALGOLIA_SEARCH_KEY, {
      headers: {
        'X-Algolia-UserToken': userId
      }
    }
  );

  var index = algolia.initIndex('niches_development');


    function handleKeywords(keywordsArr) {
      var returnString = "";
      var i;
      for (i = 0; i < keywordsArr.length; i++) {
        var keywordObj = keywordsArr[i];
        if (keywordObj.matchLevel !== "none") {
          returnString += keywordObj.value + '<br/>';
        }
      }
      return returnString;
    };

    document.getElementById("select-niches").focus();
    // $('#select-niches').select2('focus');
    $('#select-niches').select2({
      language: {
        inputTooShort: function() {
          return 'Please enter 3 or more character to search';
        },
      },
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
          return { query: params.term, hitsPerPage: 6, page: (params.page || 1) - 1, highlightPreTag: '<strong>', highlightPostTag: '</strong>', attributesToSnippet: ['description:30'], snippetEllipsisText: '...', attributesToHighlight: ['title', 'keywords']};
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
                    'Common keywords' +
                  '</div>' +
                  '<div class="w-full text-sm">' +
                    handleKeywords(niche_res._highlightResult.keywords) +
                  '</div>' +
                  '<div class="w-full text-xs mt-2 text-gray-600">' +
                    'Description' +
                  '</div>' +
                  '<div class="w-full text-sm pb-2">' +
                    niche_res._snippetResult.description.value +
                  '</div>' +
                '</div>'
        }
      }
    });


});



