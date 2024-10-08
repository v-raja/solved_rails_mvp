// import searchRouting from '../../src/navbar_routing';


$(document).on('turbolinks:load', function() {
  if (document.getElementById("searchbox_navbar")) {
    import(/* webpackChunkName: "navbar_routing" */ '../../src/navbar_routing').then(module => {
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
          other_keywords = "";
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
      if (gon.pxmalz) {
        searchClient = algoliasearch(
          process.env.ALGOLIA_APP_ID,
          process.env.ALGOLIA_SEARCH_KEY, {
            headers: {
              'X-Algolia-UserToken': atob(gon.pxmalz)
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
        indexName: 'niches_' + process.env.RAILS_ENV,
        // stalledSearchDelay: 10,
        searchClient,
        // urlSync: true,
        routing: module.default,
        searchFunction(helper) {
          if (helper.state.query.length < 2) {
            document.querySelector('#app_body').style.display = '';
            document.querySelector('#results').style.display = 'none';
            return; // no search if less than 2 character
          }

          const container = document.querySelector('#results');
          container.style.display = helper.state.query === '' ? 'none' : 'block';

          const empty_search = document.querySelector('#app_body');
          empty_search.style.display = helper.state.query === '' ? '' : 'none';

          helper.search();
        }
      });

      let timerId;
      search.addWidgets([
        instantsearch.widgets.configure({
          attributesToSnippet: ['description:200'],
          hitsPerPage: 12,
          // filters: 'NOT categories:"Cell Phones"'
        }),
        instantsearch.widgets.searchBox({
          container: '#searchbox_navbar',
          placeholder: "Search for your industry or occupation",
          searchAsYouType: true,
          queryHook(query, refine) {
            clearTimeout(timerId);
            timerId = setTimeout(() => refine(query), 400);
          },
          cssClasses: {
            form: "relative flex items-center",
            submit: "absolute inset-y-0 left-3 flex items-center",
            submitIcon: "h-4 w-4 text-gray-600 fill-current",
            input: "block pl-9 pr-4 py-1 w-full border border-transparent hover:bg-white hover:border-gray-300 placeholder-gray-600 bg-gray-200 focus:outline-none focus:bg-white focus:border-gray-300 text-gray-900 rounded-lg",
            reset: "appearance-none hidden"
          }
        }),

        instantsearch.widgets.hits({
          cssClasses: {
            root: "w-full",
            list: "w-full grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-2 mt-4",
            item: "bg-white w-full mt-0 border border-gray-400 shadow-none px-3 py-3",
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
                      '<div class="w-full text-xxs uppercase mt-1 text-gray-900">' +
                        '{{{type}}}' +
                      '</div>' +
                      '<div class="w-full text-black leading-tight text-sm sm:text-sm font-medium mt-1">' +
                        '{{{_highlightResult.title.value}}}' +
                      '</div>' +
                      '<div data-controller="toggle w-full">' +
                        '<div class="-ml-1 mb-2 w-full text-xs mt-3 text-gray-600 hover:text-black hover:font-medium flex items-center" data-action="click->toggle#toggle touch->toggle#toggle">' +
                          '<div class="hidden w-3 h-3" data-toggle-target="toggleable">' +
                            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">' +
                              '<path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />' +
                            '</svg>' +
                          '</div>' +
                          '<div class="w-3 h-3" data-toggle-target="toggleable">' +
                            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">' +
                            '<path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />' +
                            '</svg>' +
                          '</div>' +
                          '<div class="">' +
                            'Relevant keywords' +
                          '</div>' +
                        '</div>' +
                        '<div class="w-full text-xs  space-y-2.5 leading-tight" data-toggle-target="toggleable">' +
                          '{{{keyword_list}}}' +
                        '</div>' +
                      '</div>' +
                      '{{#display_other_keywords}}' +
                        '<div data-controller="toggle w-full">' +
                          '<div class="-ml-1 mb-2 w-full text-xs mt-3 text-gray-600 hover:text-black hover:font-medium flex items-center" data-action="click->toggle#toggle touch->toggle#toggle">' +
                            '<div class="w-3 h-3" data-toggle-target="toggleable">' +
                              '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">' +
                                '<path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />' +
                              '</svg>' +
                            '</div>' +
                            '<div class="hidden w-3 h-3" data-toggle-target="toggleable">' +
                              '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">' +
                              '<path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />' +
                              '</svg>' +
                            '</div>' +
                            '<div class="">' +
                              'Other keywords' +
                            '</div>' +
                          '</div>' +
                          '<div class="w-full text-xs  space-y-2.5 leading-tight hidden" data-toggle-target="toggleable">' +
                            '{{{other_keyword_list}}}' +
                          '</div>' +
                        '</div>' +
                      '{{/display_other_keywords}}' +
                      '<div data-controller="toggle">' +
                        '<div class="-ml-1 mb-2 w-full text-xs mt-3 text-gray-600 hover:text-black hover:font-medium flex items-center" data-action="click->toggle#toggle touch->toggle#toggle">' +
                          '<div class="w-3 h-3" data-toggle-target="toggleable">' +
                            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">' +
                              '<path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />' +
                            '</svg>' +
                          '</div>' +
                          '<div class="hidden w-3 h-3" data-toggle-target="toggleable">' +
                            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">' +
                            '<path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />' +
                            '</svg>' +
                          '</div>' +
                          '<div class="">' +
                            'Description' +
                          '</div>' +
                        '</div>' +
                        '<div class="w-full text-xs pb-2 hidden" data-toggle-target="toggleable">' +
                          '{{{_snippetResult.description.value}}}' +
                        '</div>' +
                      '</div>' +
                    '</div>' +
                  '</a>'
          },
        }),


        instantsearch.widgets.refinementList({
          container: '#community_type',
          attribute: 'type',
          sortBy: ['name:asc'],
          templates: {
          },
          cssClasses: {
            list: "flex items-center space-x-6 mr-6",
            count: "hidden",
            item: "flex items-center cursor-pointer",
            checkbox: "cursor-pointer appearance-none border-transparent rounded checked:bg-secondary checked:border-transparent  w-4 h-4",
            labelText: "ml-0.5 leading-tight text-xs cursor-pointer hover:underline",
          }
        }),
      ]);

      search.start();
    });
  }
})
