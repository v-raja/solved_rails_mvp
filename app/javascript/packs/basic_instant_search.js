$(document).on('turbolinks:load', function() {
  const searchClient = algoliasearch(
    process.env.ALGOLIA_APP_ID,
    process.env.ALGOLIA_ADMIN_API_KEY
  );

  const search = instantsearch({
    searchClient,
    indexName: 'niches_development',
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
      attributesToSnippet: ['description'],
      hitsPerPage: 12,
      // filters: 'NOT categories:"Cell Phones"'
    }),
    instantsearch.widgets.searchBox({
      container: '#searchbox',
      placeholder: "Search for your niche",
      searchAsYouType: true
    }),

    instantsearch.widgets.hits({
      cssClasses: {
        // item: "bg-white border border-white",
        // list: "bg-red-400"
      },
      transformItems(items) {
        var itemz = items.map(item => ({
          ...item,
          display_code: item._highlightResult.code_with_suffix.matchLevel !== 'none'
        }));
        console.log(itemz);
        return itemz;
      },
      container: '#hits',
      templates: {
        empty: 'No niches have been found for "{{ query }}"',
        // item: '<strong>Hit {{objectID}}</strong>: {{{_highlightResult.title.value}}}',
        item: '<a href={{{url}}}>' +
                '<div class="flex flex-wrap">' +
                  '<div class="w-full text-black leading-tight text-base font-medium mt-1">' +
                    '{{{_highlightResult.title.value}}}'+
                  '</div>' +
                  '<div class="w-full text-sm mt-0.5 text-gray-800">' +
                    '{{{type}}}' +
                  '</div>' +
                  '<div class="w-full text-xs mt-2 text-gray-600">' +
                    'Description' +
                  '</div>' +
                  '<div class="w-full text-base">' +
                    '{{#helpers.snippet}}{ "attribute": "description", "highlightedTagName": "strong" }{{/helpers.snippet}}' +
                  '</div>' +
                  '{{#display_code}}' +
                    '<div class="w-full text-sm mt-1">' +
                      '{{{_highlightResult.code_with_suffix.value}}}' +
                    '</div>' +
                  '{{/display_code}}' +
                '</div>' +
              '</a>'
      },
    }),

    // instantsearch.widgets
    //   .index({ indexName: 'products_development' })
    //   .addWidgets([
    //     instantsearch.widgets.hits({
    //       container: '#hits-product',
    //       templates: {
    //         empty: 'No products have been found for "{{ query }}"',
    //         item: '<a href={{{url}}}>' +
    //                 '<div class="flex flex-wrap items-end">' +
    //                   '<div class="w-20 h-20 object-cover">' +
    //                     '<img src="{{{thumbnail_url}}}"/>' +
    //                   '</div>' +
    //                   '<div class="ml-4 text-center font-semibold text-black leading-tight text-2xl">' +
    //                     '{{{_highlightResult.name.value}}}'+
    //                   '</div>' +
    //                 '</div>' +
    //               '</a>'
    //       },
    //     }),
    //   ]),

  ]);

  search.start();
});
