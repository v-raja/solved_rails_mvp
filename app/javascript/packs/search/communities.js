$(document).on('turbolinks:load', function() {
  if (document.getElementById("searchbox_communities")) {

    function handleKeywords(keywordsArr) {
      if (keywordsArr == null) {
        return "";
      }
      var returnString = "";
      var i;
      for (i = 0; i < keywordsArr.length; i++) {
        var keywordObj = keywordsArr[i];
        if (keywordObj.matchLevel !== "none") {
          returnString += '<li>' + keywordObj.value + '</li>';
        }
      }
      return returnString;
    };

    var other_keywords = "";
    function otherKeywords(keywordsArr) {
      if (keywordsArr == null) {
        return "";
      }
      var returnString = "";
      var i;
      for (i = 0; i < keywordsArr.length; i++) {
        var keywordObj = keywordsArr[i];
        if (keywordObj.matchLevel == "none") {
          returnString += '<li>' + keywordObj.value + '</li>';
        }
      }
      other_keywords = returnString;
      return returnString;
    };

    var searchClient;
    if (gon.current_user_id !== null) {
      searchClient = algoliasearch(
        process.env.ALGOLIA_APP_ID,
        process.env.ALGOLIA_SEARCH_KEY, {
          headers: {
            'X-Algolia-UserToken': gon.current_user_id
          }
        }
      );
    } else {
      searchClient = algoliasearch(
        process.env.ALGOLIA_APP_ID,
        process.env.ALGOLIA_SEARCH_KEY
      );
    }

    const search = instantsearch({
      searchClient,
      indexName: 'niches_' + process.env.RAILS_ENV,
      stalledSearchDelay: 800,
      urlSync: true,
      routing: true,
      searchFunction(helper) {
        if (helper.state.query.length < 2) {
          document.querySelector('#app_body').style.display = '';
          document.querySelector('#results').style.display = 'none';
          return; // no search if less than 2 character
        }

        const container = document.querySelector('#results');
        container.style.display = helper.state.query === '' ? 'none' : '';

        const empty_search = document.querySelector('#app_body');
        empty_search.style.display = helper.state.query === '' ? '' : 'none';

        helper.search();
      }
    });

    search.addWidgets([
      instantsearch.widgets.configure({
        attributesToSnippet: ['description:100'],
        hitsPerPage: 12,
        // filters: 'NOT categories:"Cell Phones"'
      }),
      instantsearch.widgets.searchBox({
        container: '#searchbox_communities',
        placeholder: "Search for your industry or occupation",
        searchAsYouType: true,
        cssClasses: {
          form: "relative flex items-center",
          submit: "absolute inset-y-0 left-3 flex items-center",
          submitIcon: "h-4 w-4 text-gray-600 fill-current",
          input: "block pl-9 pr-4 py-2 w-full shadow-none hover:shadow-md rounded-lg placeholder-gray-500 bg-white border border-gray-400 hover:border-transparent focus:outline-none focus:shadow-md focus:ring-transparent focus:border-transparent text-gray-900",
          reset: "absolute inset-y-0 right-2 flex items-center"
        }
      }),

      instantsearch.widgets.hits({
        cssClasses: {
          root: "w-full",
          list: "w-full grid grid-cols-3 gap-4 mt-4",
          item: "bg-white w-full mt-0 border border-gray-400 shadow-none hover:bg-blue-100 px-6 py-4",
        },
        transformItems(items) {
          var itemz = items.map(item => ({
            ...item,
            keyword_list: handleKeywords(item._highlightResult.keyword_list),
            other_keyword_list: otherKeywords(item._highlightResult.keyword_list),
            display_other_keywords: other_keywords !== "",
          }));
          // console.log(itemz);
          return itemz;
        },
        container: '#hits',
        templates: {
          empty: 'No communities have been found for "{{ query }}"',
          item: '<a href={{{url}}}>'+
                  '<div class="flex flex-col text-black">' +
                    '<div class="w-full text-sm uppercase mt-1 text-gray-900">' +
                      '{{{type}}}' +
                    '</div>' +
                    '<div class="w-full text-black leading-tight text-base font-medium mt-1">' +
                      '{{{_highlightResult.title.value}}}' +
                    '</div>' +
                    '<div class="w-full text-xs mt-3 mb-1 text-gray-700">' +
                      'Relevant keywords' +
                    '</div>' +
                    '<div class="w-full text-sm list-disc list-inside space-y-0.5">' +
                      '{{{keyword_list}}}' +
                    '</div>' +
                    '{{#display_other_keywords}}' +
                      '<div data-controller="toggle w-full">' +
                        '<div class="-ml-4 mb-1 w-full text-xs mt-3 text-gray-700 hover:text-black hover:font-medium flex items-center" data-action="click->toggle#toggle touch->toggle#toggle">' +
                          '<div class="w-4 h-4" data-toggle-target="toggleable">' +
                            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">' +
                              '<path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />' +
                            '</svg>' +
                          '</div>' +
                          '<div class="hidden w-4 h-4" data-toggle-target="toggleable">' +
                            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">' +
                            '<path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />' +
                            '</svg>' +
                          '</div>' +
                          '<div class="">' +
                            'Other keywords' +
                          '</div>' +
                        '</div>' +
                        '<div class="w-full text-sm list-disc list-inside space-y-0.5 hidden" data-toggle-target="toggleable">' +
                          '{{{other_keyword_list}}}' +
                        '</div>' +
                      '</div>' +
                    '{{/display_other_keywords}}' +
                    '<div data-controller="toggle">' +
                      '<div class="-ml-4 mb-1 w-full text-xs mt-3 text-gray-700 hover:text-black hover:font-medium flex items-center" data-action="click->toggle#toggle touch->toggle#toggle">' +
                        '<div class="w-4 h-4" data-toggle-target="toggleable">' +
                          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">' +
                            '<path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />' +
                          '</svg>' +
                        '</div>' +
                        '<div class="hidden w-4 h-4" data-toggle-target="toggleable">' +
                          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">' +
                          '<path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />' +
                          '</svg>' +
                        '</div>' +
                        '<div class="">' +
                          'Description' +
                        '</div>' +
                      '</div>' +
                      '<div class="w-full text-sm pb-2 hidden" data-toggle-target="toggleable">' +
                        '{{{_snippetResult.description.value}}}' +
                      '</div>' +
                    '</div>' +
                  '</div>' +
                '</a>'
          // '<a href={{{url}}}>' +
          //         '<div class="flex flex-wrap">' +
          //           '<div class="w-full text-black leading-tight text-base font-medium mt-1">' +
          //             '{{{_highlightResult.title.value}}}'+
          //           '</div>' +
          //           '<div class="w-full text-sm mt-0.5 text-gray-800">' +
          //             '{{{type}}}' +
          //           '</div>' +
          //           '<div class="w-full text-xs mt-2 text-gray-600">' +
          //             'Description' +
          //           '</div>' +
          //           '<div class="w-full text-base">' +
          //             '{{#helpers.snippet}}{ "attribute": "description", "highlightedTagName": "strong" }{{/helpers.snippet}}' +
          //           '</div>' +
          //           '{{#display_code}}' +
          //             '<div class="w-full text-sm mt-1">' +
          //               '{{{_highlightResult.code_with_suffix.value}}}' +
          //             '</div>' +
          //           '{{/display_code}}' +
          //         '</div>' +
          //       '</a>'
        },
      }),
    ]);

    search.start();
  }
})
