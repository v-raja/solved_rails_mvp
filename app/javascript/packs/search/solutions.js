import searchRouting from '../../src/search_routing';


$(document).on('turbolinks:load', function() {
  if (document.getElementById("searchbox_posts")) {
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
      indexName: gon.index_name + '_' + process.env.RAILS_ENV,
      // urlSync: true,
      routing: searchRouting,
        // stateMapping: instantsearch.stateMappings.simple(),
        // router: router
      //   searchRouting
      // }
      // searchFunction(helper) {
      //   if (helper.state.query.length < 2) {
      //     document.querySelector('#app_body').style.display = '';
      //     document.querySelector('#results').style.display = 'none';
      //     return; // no search if less than 2 character
      //   }

      //   const container = document.querySelector('#results');
      //   container.style.display = helper.state.query === '' ? 'none' : '';

      //   const empty_search = document.querySelector('#app_body');
      //   empty_search.style.display = helper.state.query === '' ? '' : 'none';

      //   helper.search();
      // }
    });

    search.addWidgets([
      instantsearch.widgets.configure({
        // attributesToSnippet: ['description:100'],
        // hitsPerPage: 12,
        // filters: 'NOT categories:"Cell Phones"'
      }),
      instantsearch.widgets.searchBox({
        container: '#searchbox_posts',
        placeholder: "Search for a problem you have (press enter to search)",
        searchAsYouType: false,
        cssClasses: {
          form: "relative flex items-center",
          input: "block pl-9 pr-4 py-2 w-full shadow-none hover:shadow-md rounded-lg placeholder-gray-500 bg-white border border-gray-400 hover:border-transparent focus:outline-none focus:shadow-md focus:ring-transparent focus:border-transparent text-gray-900",
          submit: "absolute inset-y-0 left-3 flex items-center",
          submitIcon: "h-4 w-4 text-gray-600 fill-current",
          reset: "hidden"
        }
      }),

      instantsearch.widgets.hits({
        container: '#hits',
        cssClasses: {
          root: "w-full",
          list: "w-full flex flex-col space-y-3",
          item: "m-0 p-0 px-5 bg-white overflow-x-auto border border-gray-400 w-full hover:border-gray-900 group",
        },
        transformItems(items) {
          var itemz = items.map(item => ({
            ...item,
            // keyword_list: handleKeywords(item._highlightResult.keyword_list),
            // other_keyword_list: otherKeywords(item._highlightResult.keyword_list),
            // display_other_keywords: other_keywords !== "",
          }));
          console.log(itemz);
          return itemz;
        },
        templates: {
          empty: 'No solutions have been found for "{{ query }}"',
          item: '<a href={{{url}}} target="_blank">'+
                  '<div class="">' +
                    '<div class="flex flex-col rounded-sm py-5">' +
                      '<div class="w-full flex items-stretch">' +
                          '<div class="w-16 h-16 flex-shrink-0">' +
                            // '<a href={{{product.url}}}>' +
                            '<img src={{{product.thumbnail_url}}} class="object-cover"/>' +
                            // '</a>' +
                          '</div>' +
                          '<div class="pl-3 flex-grow h-max w-min flex flex-col justify-between overflow-x-auto overflow-y-hidden">' +
                            '<div class="font-medium two-lines-only">' +
                              '{{{_highlightResult.title.value}}}' +
                            '</div>' +
                            '<div class="text-xs text-gray-600 flex flex-wrap">' +
                              '<div class="flex-shrink-1 truncate text-black flex items-center">' +
                                '<div class="font-medium">' +
                                  '{{{communities.0.title}}}' +
                                '</div>' +
                                '<div class="mx-1 text-gray-600">' +
                                  '&middot;' +
                                '</div>' +
                              '</div>' +
                              '<div class="hover:text-black flex-shrink-0 pr-2">' +
                                '{{{user.name}}}' +
                              '</div>' +
                            '</div>' +
                          '</div>' +
                          '<div class="ml-6 text-gray-900 place-self-center flex-shrink-0 flex flex-col items-center justify-center w-14 h-16 rounded border border-gray-300 leading-none transition group-hover:text-primary">' +
                            '<div class="text-sm leading-none group-hover:animate-bounce">' +
                              '▲' +
                            '</div>' +
                            '<div class="mt-1 font-semibold">' +
                              '{{{nb_votes}}}' +
                            '</div>' +
                          '</div>' +
                      '</div>' +
                      `<div class=" video aspect-w-7 aspect-h-4 mt-6 hidden">
                        <div class=" flex flex-col w-full h-full overflow-y-auto space-y-2">
                          <div class=" aspect-w-16 aspect-h-9 w-full flex-shrink-0">
                            <iframe allowfullscreen="1" class=" h-full w-full" frameborder="0" src="https://www.youtube-nocookie.com/embed/{{{videos.0.youtube_id}}}?rel=0"></iframe>
                          </div>
                        </div>
                      </div>` +
                    '</div>' +
                  '</div>' +
                '</a>'
        },
      }),

      instantsearch.widgets.refinementList({
        container: '#tags',
        attribute: '_tags',
        searchable: true,
        showMore: true,
        limit: 8,
        templates: {
          item: `
          <a href="{{url}}" class="{{#isRefined}}font-bold{{/isRefined}}">
            <span class="ml-1 hover:underline">{{label}}  ({{count}})</span>
          </a>
        `,
        },
        placeholder: "Search for a tag",
        cssClasses: {
          searchableForm: "border-0",
          searchableInput: "bg-transparent border-0 focus:outline-none focus:ring-0 focus:border-secondary border-b-3 border-secondary",
          // root: the root element of the widget.
          list: "mt-4 space-y-2",
          // item: the list items. They contain the link and separator.
          // selectedItem: each selected item in the list.
          // label: "{{{label}}}}1",
          // checkbox: each checkbox element (when using the default template).
          // labelText: each label text element.
          showMore: "text-sm mt-4 font-medium hover:underline focus:outline-none",
          disabledShowMore: "hidden",
          // count: each count element (when using the default template).
          // searchableRoot: the root element of the search box.
          // searchableSubmit: "hidden",
          // searchableSubmitIcon: the reset button icon of the search box.
          searchableReset: "hidden"
          // searchableLoadingIndicator: the submit button element of the search box.
          // searchableLoadingIcon: the submit button icon of the search box.
        }
      }),

      instantsearch.widgets.refinementList({
        container: '#communities',
        attribute: 'communities.title',
        searchable: true,
        showMore: true,
        limit: 6,
        templates: {
          item: `
          <a href="{{url}}" class="{{#isRefined}}font-bold{{/isRefined}}">
            <span class="text-sm hover:underline">{{label}} ({{count}})</span>
          </a>
        `,
        },
        placeholder: "Search for a community",
        cssClasses: {
          searchableForm: "border-0",
          searchableInput: "bg-transparent border-0 focus:outline-none focus:ring-0 focus:border-secondary border-b-3 border-secondary",
          list: "mt-4 space-y-3",
          searchableReset: "hidden",
          item: "leading-none",
          showMore: "text-sm mt-4 font-medium hover:underline focus:outline-none",
          disabledShowMore: "hidden"
        }
      }),



    ]);

    search.start();
  }
})

